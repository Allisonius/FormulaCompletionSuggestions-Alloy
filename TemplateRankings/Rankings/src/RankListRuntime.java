import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;
import java.util.TreeMap;
import java.util.TreeSet;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import RankPriority.CrossProduct;
import RankPriority.Difference;
import RankPriority.Equals;
import RankPriority.ExtendsOp;
import RankPriority.In;
import RankPriority.Intersection;
import RankPriority.Join;
import RankPriority.NotEquals;
import RankPriority.NotIn;
import RankPriority.Union;
import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.ErrorWarning;
import edu.mit.csail.sdg.ast.Command;
import edu.mit.csail.sdg.ast.Decl;
import edu.mit.csail.sdg.ast.Expr;
import edu.mit.csail.sdg.ast.ExprBinary;
import edu.mit.csail.sdg.ast.ExprCall;
import edu.mit.csail.sdg.ast.ExprChoice;
import edu.mit.csail.sdg.ast.ExprConstant;
import edu.mit.csail.sdg.ast.ExprHasName;
import edu.mit.csail.sdg.ast.ExprITE;
import edu.mit.csail.sdg.ast.ExprLet;
import edu.mit.csail.sdg.ast.ExprList;
import edu.mit.csail.sdg.ast.ExprQt;
import edu.mit.csail.sdg.ast.ExprUnary;
import edu.mit.csail.sdg.ast.ExprVar;
import edu.mit.csail.sdg.ast.Func;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.TranslateAlloyToKodkod;

public class RankListRuntime {
	//Order of all variables that are in scope
	static ArrayList<String> order = new ArrayList<String>();
	static HashSet<String> lets = new HashSet<String>();
		
	public static void main (String [] args) {
		
		//What models and suggestions to read in to re-rank using templates
		String source = "formula";
		//String source = "generator";

		//All models
		/*String [] models = {"array", "bempl", "binary-tree", "class-diagram", "classroom", "classroom-fol", "classroom-rl", "courses-v1",
				"courses-v2", "c-tree", "cv", "dll", "fsm", "grade", "graph", "handshake", "lts", "nqueens", 
				"production-line-v1", "production-line-v2", "production-line-v3", "singly-linked-list", "social-media", "train-station-fol",
				"train-station-ltl", "trash-fol", "trash-ltl", "trash-rl", */
		
		String [] models = {"frankervrep","git","icd","java_meta_model", "modelo-alloy","hamsters","kafka","ledger","lib"};
		
		//Where to store the results and result string to print at the end
		String result_dir = "results" + File.separator;
		
		//Store information for printing metrics
		String print_details = "";
		

		for(String model : models) {
			//Build the relevant directory locations.
			//Directory where the json file is stored from the completion suggestion generator
			String directory = "test-results" + File.separator + source + File.separator + "multi_term" + File.separator + model + File.separator;
			//Location where the model under consideration is stored
			String model_dir = "models" + File.separator;
			
			//Gather all the files produced by the completion suggestion framework
			File folder = new File(directory);
			File[] listOfFiles = folder.listFiles();
			
			
			
			//Configure objects for Analyzer commmand executions
			A4Reporter rep = new A4Reporter() {
		          @Override
		          public void warning(ErrorWarning msg) {
		              System.out.println(msg.toString().trim());
		              System.out.flush();
		          }
			    }; 
		     A4Options options = new A4Options();
		     options.solver = A4Options.SatSolver.SAT4J; //This SAT solver is Alloy's default 
		     
		     
		     //Parse model
		     CompModule world;
		     ArrayList<Parameter> parameters = new ArrayList<Parameter>();
			 
		     long start_time = System.nanoTime();
		     int num_loc = 0;
		     int empty_sug = 0;
			 for(File file : listOfFiles) {
				String f = file.getName(); //The json files contains all the suggestions and all details about the completion location
				if(f.contains("json")  ) {
					if(f.contains("true"))
						num_loc++;
					
					//Reset world to remove any parameters stored as global variables
					if(f.contains("fixable")) { //If model had variables declared on a different line in the file, then parse the model with variable use inlined with variable declarations
						world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + "-fixable" + ".als"); 
						
						//reset parameter locations
						parameters = getParameterLocs(world);
					}
					else {
						world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + ".als");
						
						//reset parameter locations
						parameters = getParameterLocs(world);
					}
					
					long alt_start_time = System.nanoTime();
					//Will store the order the template ranking produces, printed to result file and used by contrasting scenario
					ArrayList<String> template_rank_ordered_sug = new ArrayList<String>();
					
					File myObj = new File(directory + f);
				    Scanner myReader;
				    Object obj = null;
				    try {
						myReader = new Scanner(myObj);
						while (myReader.hasNextLine()) {

							String data = myReader.nextLine();
							obj = new JSONParser().parse(data);
							JSONObject jo = (JSONObject) obj; 
							
							String term = (String) jo.get("term"); //Get completion term
							
							//Get incomplete line - adjust mismatch when operator is !in and != as term gets incorrectly stored
							String incompleteLine = (String) jo.get("incompletionLine");
							if(term.equals(" in ")) {
								if(incompleteLine.endsWith(" not in"))
									term = " not in ";
							}
							else if(term.equals(" = ")) {
								if(incompleteLine.endsWith(" not ="))
									term = " not = ";
							}
							
							//Gather completion context
							CompletionLineTemplates lineTemplate = new CompletionLineTemplates(model, model_dir);
							String loc_template = lineTemplate.cleanLine(incompleteLine, term, model);					
							String expectedCompletionWord = (String) jo.get("expectedCompletionWord");			
							String expectedCompletionLine = (String) jo.get("expectedCompletionLine");
							long line_number = (Long) jo.get("line");
							
							//Add parameter variables to the Analyzer's execution environment
							for(Parameter p : parameters) {
								if(line_number >= p.start_line && line_number <= p.end_line) {
									world.addGlobal(p.variable, CompUtil.parseOneExpression_fromString(world, p.type));
								}
							}
							
							//Narrow in on completion term extraction
							String [] temp = expectedCompletionLine.split(" ");
							if(temp.length > 1) {
								if ( temp[1].equals("->") || temp[1].equals("<:")|| temp[1].equals(":>")) {
									expectedCompletionLine = temp[0] + " " + temp[1] + " " + temp[2];
								}
								else {
									expectedCompletionLine = temp[0];
								}
							}
							else {
								expectedCompletionLine = temp[0];
							}
							
							if(expectedCompletionLine.contains("[")) {
								expectedCompletionLine = expectedCompletionLine.substring(0, expectedCompletionLine.indexOf("["));
							}
							expectedCompletionLine = expectedCompletionLine.replaceAll("\\(","");
							expectedCompletionLine = expectedCompletionLine.replaceAll("\\)","");
							
							
							
							expectedCompletionLine = clean_expectedCompletionLine(expectedCompletionLine);
							incompleteLine = clean_incompleteLine(incompleteLine);
							String line = incompleteLine + " " + expectedCompletionLine; //rebuild line
							
							//Store all variables in scope of completion suggestion
							HashMap<String, String> vars = new HashMap<String, String>();
							
							line = line.trim();
							if(line.startsWith("pred ")) { //inlined pred
								if(line.contains("}")) {
									line = line.substring(line.indexOf("{") + 1);
									line = line.substring(0, line.lastIndexOf("}"));
								}
								else {
									line = line.substring(line.indexOf("{") + 1);
								}
							}
							
							if(line.startsWith("fact ")  && line.contains("}")) { // inline fact
								line = line.substring(line.indexOf("{") + 1);
								line = line.substring(0, line.lastIndexOf("}"));
							}
							
							if(line.startsWith("fun ")  && line.contains("}")) { // inline function
								line = line.substring(line.indexOf("{") + 1);
								line = line.substring(0, line.lastIndexOf("}"));
							}
							
							Expr line_expr = null;
							try {
								try {
									line_expr = CompUtil.parseOneExpression_fromString(world, line);	
									vars = findVars(line_expr, vars); //Iterate over completion location, find all variables in scope. Note: not needed if directly connected to completion pipeline as these are gathered there 
								}
								catch(Exception e) {
									line = line.replaceAll("\\(", "");
									line = line.replaceAll("\\)", "");
									line_expr = CompUtil.parseOneExpression_fromString(world, line);	
									vars = findVars(line_expr, vars); //Iterate over completion location, find all variables in scope. Note: not needed if directly connected to completion pipeline as these are gathered there 
								}
							}
							catch(Exception e2) {
								
							}
							
							String start_line = ""; //stores quantified variable declarations
							String end_line = ""; //stores end of quantified declarations
							String disj = "";
							
							//For all variables in scope, build existentially quantified or let expressions to properly declare the variables
							for(int i = 0; i < order.size(); i++) {
								if(lets.contains(order.get(i))){
									world.addGlobal(order.get(i), CompUtil.parseOneExpression_fromString(world, vars.get(order.get(i))));
									start_line += " some " + order.get(i) + " : " + vars.get(order.get(i)) + " { " ;
									end_line += "}";
								}
								else {
									world.addGlobal(order.get(i), CompUtil.parseOneExpression_fromString(world, vars.get(order.get(i))));
									start_line += " some  " + order.get(i) + " : " + vars.get(order.get(i)) + " { ";
									end_line += "}";
								}
							}
							//If any two variables have the exact same domain, make sure their variables differ
							if(order.size() > 1) {
								for(int i = 0; i < order.size(); i++) {
									for(int j = i + 1; j < order.size(); j++) {
										if(vars.get(order.get(i)).equals(vars.get(order.get(j)))) {
											disj += order.get(i) + " != " + order.get(j) + "\n";
										}
									}
								}
							}

							//Get the list of suggestions
							JSONArray evaluationResult = (JSONArray) jo.get("evaluationResult");

							//Storage for results
							//Stores suggestions by priority level
							TreeMap<Integer, TreeSet<SuggestionResult>> ranked_suggestions = new TreeMap<Integer, TreeSet<SuggestionResult>>();
				
							//Builds baseline: alphanetical ranking and length based ranking
							TreeSet<String> suggestions = new TreeSet<String>();
				
							//Iterate over all suggestions
							
							if( evaluationResult.size() == 0)
								empty_sug++;
							
							for(int i = 0; i < evaluationResult.size(); i++) {
							
								
								JSONObject result = (JSONObject) evaluationResult.get(i);
								String suggestion = (String) result.get("suggestion");
								suggestions.add(suggestion);
								
								JSONArray breakdown = (JSONArray) result.get("expressionComponents");
								long rank = (long) result.get("rank");
								
								// Build template of the suggestion				
								String template = "";
								for(int j = 0; j < breakdown.size(); j++) {
									JSONObject component = (JSONObject) breakdown.get(j);
									String label = (String) component.get("label");
									String type = (String) component.get("type");
									if(type.equals("OPERATOR")) {
										template += label;
									}
									else if (type.equals("OTHER")) {
										template += "VARIABLE";
									}
									else {
										template += type;
									}
								}
																
								int level = 0;
								//Find priority level
								if(term.equals(".")) {
									Join join = new Join();
									level = join.priorityLevel(loc_template, template);
								}
								else if(term.equals(" -> ")) {
									CrossProduct cross_product = new CrossProduct();
									level = cross_product.priorityLevel(loc_template, template);
								}
								else if(term.equals(" in ")) {
									In in = new In();
									level = in.priorityLevel(loc_template, template);
								}
								else if(term.equals(" not in ")) {
									NotIn not_in = new NotIn();
									level = not_in.priorityLevel(loc_template, template);
								}
								else if(term.equals(" = ")) {
									Equals equals = new Equals();
									level = equals.priorityLevel(loc_template, template);
								}
								else if(term.equals(" not = ")) {
									NotEquals not_equals = new NotEquals();
									level = not_equals.priorityLevel(loc_template, template);
								}
								else if(term.equals(" & ")) {
									Intersection intersection = new Intersection();
									level = intersection.priorityLevel(loc_template, template);
								}
								else if(term.equals(" + ")) {
									Union union = new Union();
									level = union.priorityLevel(loc_template, template);
								}
								else if(term.equals(" - ")) {
									Difference difference = new Difference();
									level = difference.priorityLevel(loc_template, template);
								}
								else if(term.equals(" extends ")) { 
									ExtendsOp extendsop = new ExtendsOp();
									level = extendsop.priorityLevel(loc_template, template);
								}
			
								//Set built in sets to max level
								if(suggestion.equals("Int") || suggestion.equals("String") || suggestion.equals("seq/Int")) {
									level = Integer.MAX_VALUE;
								}

								//Build suggestion rank object
								SuggestionResult suggestion_result = new SuggestionResult(suggestion, template, loc_template, false, false, false, rank, level);

								if(ranked_suggestions.containsKey(level)) {
									ranked_suggestions.get(level).add(suggestion_result);
								}
								else {
									ranked_suggestions.put(level, new TreeSet<SuggestionResult>());
									ranked_suggestions.get(level).add(suggestion_result);
								}
							}
							
							//Organize ranked list
							long rank = 1;
							for(int i : ranked_suggestions.keySet()) {
								for(SuggestionResult suggestion : ranked_suggestions.get(i)) {
									template_rank_ordered_sug.add(suggestion.suggestion);
									suggestion.setRank(rank);
									rank++;
									
								}
							}							
						}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						System.out.println(f);
					}
	
				    order = new ArrayList<String>();
				    lets = new HashSet<String>();
				}
				
			}
			 System.out.println(empty_sug);
			 long end_time = System.nanoTime();
			 //store details on performance
		    long runtime = (end_time- start_time) / 1000000;
			print_details += model + "," + runtime + "," + num_loc + "\n";

		}
		try {
			  FileWriter myWriter = new FileWriter(result_dir + source + "_runtimes.txt");
		      myWriter.write(print_details);
		      myWriter.close();
	    } catch (IOException e) {
	      System.out.println("An error occurred.");
	      e.printStackTrace();
	    }
	}
	
	public static String clean_expectedCompletionLine(String expectedCompletionLine) {
		if(expectedCompletionLine.contains("//")) {
			expectedCompletionLine = expectedCompletionLine.substring(0, expectedCompletionLine.indexOf("//"));
		}
		if(expectedCompletionLine.endsWith(" or") || expectedCompletionLine.endsWith(" =>") || expectedCompletionLine.endsWith(" &&")) {
			expectedCompletionLine = expectedCompletionLine.substring(0,expectedCompletionLine.length()-2);
		}
		if(expectedCompletionLine.endsWith(" and") ) {
			expectedCompletionLine = expectedCompletionLine.substring(0,expectedCompletionLine.length()-3);
		}
		if(expectedCompletionLine.endsWith(" implies") ) {
			expectedCompletionLine = expectedCompletionLine.substring(0,expectedCompletionLine.length()-7);
		}
		if(expectedCompletionLine.endsWith("|") ) {
			expectedCompletionLine = expectedCompletionLine + "{}";
		}
		if(expectedCompletionLine.endsWith("{") ) {
			expectedCompletionLine = expectedCompletionLine + "}";
		}
		if(expectedCompletionLine.endsWith(" &") ) {
			expectedCompletionLine = expectedCompletionLine.substring(0,expectedCompletionLine.length()-1);
		}
		if(expectedCompletionLine.endsWith("&&") ) {
			expectedCompletionLine = expectedCompletionLine.substring(0,expectedCompletionLine.length()-2);
		}
		return expectedCompletionLine;
	}
	
	public static String clean_incompleteLine(String incompleteLine) {
		if(incompleteLine.startsWith("&&") || incompleteLine.startsWith("||") || incompleteLine.startsWith("=>")) {
			incompleteLine = incompleteLine.substring(2);
		}
		if(incompleteLine.startsWith("and ") ) {
			incompleteLine = incompleteLine.substring(3);
		}
		if(incompleteLine.startsWith("else ") ) {
			incompleteLine = incompleteLine.substring(4);
		}
		return incompleteLine;
	}
	
	//Iterate over completion location, find all variables used
		public static HashMap<String, String> findVars(Expr expr, HashMap<String, String> vars){
			
			if(expr instanceof ExprBinary) {
				ExprBinary binExp = (ExprBinary) expr;
				findVars(binExp.left, vars);
				findVars(binExp.right, vars);
			}
			else if(expr instanceof ExprCall) {
				//Nothing to do
			}
			else if(expr instanceof ExprChoice) {
				ExprBinary binExp = (ExprBinary) expr;
				findVars(binExp.left, vars);
				findVars(binExp.right, vars);
			}
			else if(expr instanceof ExprConstant) {
				//Nothing to do					
			}
			else if(expr instanceof ExprHasName) {
				//Nothing to do
			}
			else if(expr instanceof ExprITE) {
				ExprITE exp = (ExprITE) expr;
				findVars(exp.cond, vars);
				findVars(exp.right, vars);
				findVars(exp.left, vars);
			}
			else if(expr instanceof ExprLet) {
				ExprLet exp = (ExprLet) expr;
				String type = exp.var.type().toString();
				type = type.replaceAll("this/", "");
				type = type.replaceAll("\\}", "");
				type = type.replaceAll("\\{", "");
				vars.put(exp.var.label, type);
				if(!order.contains(exp.var.label))
					order.add(exp.var.label);
				lets.add(exp.var.label);
				findVars(exp.expr, vars);
				findVars(exp.sub, vars);
			}
			else if(expr instanceof ExprList) {
				ExprList exp = (ExprList) expr;
				for(Expr e : exp.args) {
					findVars(e, vars);
				}			
			}
			else if(expr instanceof ExprQt) {
				ExprQt exp = (ExprQt) expr;
				for(Decl decl : exp.decls) {
					for(ExprHasName var : decl.names) {
						String type = decl.expr.toString();
						type = type.replaceAll("this/", "");
						if(type.startsWith("one ")) {
							type = type.substring(4);
						}
						
						type = decl.expr.type().toString();
						type = type.replaceAll("this/", "");
						if(type.contains(",")) {
							String [] temp = type.split(",");
							String union = "";
							type = "";
							for(String s : temp) {
								type += union + s;
								union = " + ";
							}
						}
						
						vars.put(var.label, type);
						if(!order.contains(var.label))
							order.add(var.label);
						//System.out.println(var.label + " - " + type);		
					}
				}
				findVars(exp.sub, vars);
				return vars;
			}
			else if(expr instanceof ExprUnary) {
				ExprUnary exp = (ExprUnary) expr;
				findVars(exp.sub, vars);
				
			}
			else if(expr instanceof ExprVar) {
				//ExprVar exp = (ExprVar) expr;
				//vars.put(exp.label, exp.type().toString());
				//return vars;
			}
			return vars;		
		}
		
		public static ArrayList<Parameter> getParameterLocs(CompModule world){
			ArrayList<Parameter> parameters = new ArrayList<Parameter>();
		    for(Func pred : world.getAllFunc()) {
		    	for(ExprVar ev : pred.params()) {
		    		parameters.add(new Parameter(ev.label, ev.type().toString(), pred.pos.y, pred.pos.y2));
		    	}
		    } 
		    return parameters;
		}

	public static void listFilesForFolder(final File folder) {
	    for (final File fileEntry : folder.listFiles()) {
	        if (fileEntry.isDirectory()) {
	            listFilesForFolder(fileEntry);
	        } else {
	            System.out.println(fileEntry.getName());
	        }
	    }
	}
}
