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

public class RankList {
	//Order of all variables that are in scope
	static ArrayList<String> order = new ArrayList<String>();
	static HashSet<String> lets = new HashSet<String>();
		
	public static void main (String [] args) {
		
		//What models and suggestions to read in to re-rank using templates
		//String source = "llm";
		//String source = "formula";
		String source = "generator";
		
		//Benchmark models
		/*String [] models = {"array", "bempl", "binary-tree", "class-diagram", "classroom", "classroom-fol", "classroom-rl", "courses-v1",
				"courses-v2", "c-tree", "cv", "dll", "fsm", "grade", "graph", "handshake", "lts", "nqueens", 
				"production-line-v1", "production-line-v2", "production-line-v3", "singly-linked-list", "social-media", "train-station-fol",
				"train-station-ltl", "trash-fol", "trash-ltl", "trash-rl"
		};*/

		//Large models
		String [] models = {"frankervrep","git","icd","java_meta_model", "modelo-alloy"};/**/
				
		//Where to store the results and result string to print at the end
		String result_dir = "results" + File.separator;
		
		//Store information for printing metrics
		String syn_with_ranks = "";
		String first_with_ranks = "";
		String print_details = "";
		
		String syn_total = "";
		String first_total = "";

		for(String model : models) {
			
			//Build the relevant directory locations.
			//Directory where the json file is stored from the completion suggestion generator
			String directory = "test-results" + File.separator + source + File.separator + "multi_term" + File.separator + model + File.separator;
			//Location where the model under consideration is stored
			String model_dir = "models" + File.separator;
			
			//Gather all the files produced by the completion suggestion framework
			File folder = new File(directory);
			File[] listOfFiles = folder.listFiles();
			
			//Measure some high level metrics across all completion locations
			int total_exact = 0;
			int total_sem = 0;
			int total_suggestions = 0;
			int total_start_term = 0;
			
			//Store information about where different types of correct suggestions are in the ranked list
			HashSet<String> loc_exact = new HashSet<String>();
			HashSet<String> loc_sem = new HashSet<String>();
			HashSet<String> loc_start = new HashSet<String>();
			HashSet<String> loc_start_or_match = new HashSet<String>();
			
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
		     CompModule world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + ".als");

		     //Collect any parameters - each parameter is an in scope designed variable
		    ArrayList<Parameter> parameters = new ArrayList<Parameter>();
			    
			 for(File file : listOfFiles) {
				String f = file.getName(); //The json files contains all the suggestions and all details about the completion location
				if(f.contains("json")  ) {
					
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
							
					
							//Some completion locations are inlined with the declaration of the fact/pred/func - remove these declarations for we have a standalone compilable formula
							//Check for and remove inline declarations
							String inline = incompleteLine + expectedCompletionLine;

							if(inline.startsWith("pred ") || inline.startsWith("fact ") || inline.startsWith("func ")) { 
								if(inline.contains("}")) {
									incompleteLine = incompleteLine.substring(incompleteLine.indexOf("{") + 1);
									expectedCompletionLine = expectedCompletionLine.substring(0, expectedCompletionLine.lastIndexOf("}"));
								}
								else {
									incompleteLine = incompleteLine.substring(incompleteLine.indexOf("{") + 1);
								}
							}
							
							//Add parameter variables to the Analyzer's execution environment if completion line is within scope of the parameter variable
							for(Parameter p : parameters) {
								if(line_number >= p.start_line && line_number <= p.end_line) {
									world.addGlobal(p.variable, CompUtil.parseOneExpression_fromString(world, p.type));
								}
							}
							
							//Narrow in on completion term extraction
							String [] temp = expectedCompletionLine.split(" ");
							if(temp.length > 1) {
								if ( temp[1].equals("->")) {
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
							Expr line_expr = null;
							
							String start_line = ""; //stores quantified variable declarations
							String end_line = ""; //stores end of quantified declarations
							String disj = "";
							
							try { //Attempts to compile the reconstructed formula in order to gather all variables and their domain
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
							HashMap<Integer, TreeSet<String>> suggestions_by_len = new HashMap<Integer, TreeSet<String>>();
							
							//Stores all suggestions that match syntatic, and first semantic correct suggestion (which could also be syntacticly correct)
							TreeSet<SuggestionResult> syn_corr_suggetions = new TreeSet<SuggestionResult>();
							TreeSet<SuggestionResult> first_corr_suggetions = new TreeSet<SuggestionResult>();

							//Iterate over all suggestions
							for(int i = 0; i < evaluationResult.size(); i++) {
								total_suggestions++;
								
								JSONObject result = (JSONObject) evaluationResult.get(i);
								String suggestion = (String) result.get("suggestion");
								suggestions.add(suggestion);
								
								if(!suggestions_by_len.containsKey(suggestion.length())) {
									suggestions_by_len.put(suggestion.length(), new TreeSet<String>());
								}
								suggestions_by_len.get(suggestion.length()).add(suggestion);
								
								JSONArray breakdown = (JSONArray) result.get("expressionComponents");
								long rank = (long) result.get("rank");
								
								
								boolean doesMatchExactly = false;
								boolean doesMatchSyntactically = false;
								boolean doesMatchSemantically = false;
								
								if(expectedCompletionLine.equals(suggestion) ) { 
								//if(expectedCompletionLine.equals(suggestion) || expectedCompletionWord.equals(suggestion) ) { // can toggle expectedCompletionWord as acceptable as well
									//If exact match, means syntatic and semantic match
									doesMatchExactly = true;
									doesMatchSyntactically = true;
									doesMatchSemantically = true;
									loc_exact.add(f);
									loc_sem.add(f);
									loc_start_or_match.add(f);
								}
								else {
									
									//Determine if it would be a start + match
									if(expectedCompletionWord.startsWith(suggestion)) {
										total_start_term++;
										loc_start.add(f);
										loc_start_or_match.add(f);
									}
									
									//Check the suggestion for semantic equivalence
									String expression = "";
									//incompleteLine = clean_incompleteLine(incompleteLine);
									try {
										int scope = 3;

										if(incompleteLine.startsWith("(")) {
											expression = "(" + incompleteLine + " " + suggestion + ")) <=> " + "(" + incompleteLine + " " + expectedCompletionLine + ")) ";
										}
										else {
											expression = "(" + incompleteLine + " " + suggestion + ") <=> " + "(" + incompleteLine + " " + expectedCompletionLine + ") ";
										}
										Expr new_pred = CompUtil.parseOneExpression_fromString(world, expression);
										Command cmd = new Command(false, scope, scope, scope, world.getAllReachableFacts().and(new_pred));
									    A4Solution instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), cmd, options);
										if(instance.satisfiable()) {
											doesMatchSemantically = true;
											loc_sem.add(f);
											loc_start_or_match.add(f);
										}
										else {
											doesMatchSemantically = false;
										}
									}
									catch (Exception e) {
										try {
											int scope = 3;
											
											if(incompleteLine.startsWith("(")) {
												expression = "(" + incompleteLine + " " + suggestion + ")) != " + "(" + incompleteLine + " " + expectedCompletionLine + ")) ";
											}
											else {
												expression = "(" + incompleteLine + " " + suggestion + ") != " + "(" + incompleteLine + " " + expectedCompletionLine + ") ";
											}
											Expr new_pred = CompUtil.parseOneExpression_fromString(world, expression);
											Command cmd = new Command(false, scope, scope, scope, world.getAllReachableFacts().and(new_pred));
										    A4Solution instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), cmd, options);
											if(!instance.satisfiable()) {
												doesMatchSemantically = true;
												loc_sem.add(f);
												loc_start_or_match.add(f);
											}
											else {
												doesMatchSemantically = false;
											}
										}
										catch(Exception e2) {
											try {
												int scope = 3;
												
												if(incompleteLine.startsWith("(")) {
													expression = start_line + "\n" + disj + "\n" + "(" + suggestion + ")) != " + "(" + expectedCompletionLine + "))" + end_line;
												}
												else {
													expression = start_line + "\n" + disj + "\n" + "(" + suggestion + ") != " + "(" + expectedCompletionLine + ")" + end_line;
												}
												Expr new_pred = CompUtil.parseOneExpression_fromString(world, expression);
												Command cmd = new Command(false, scope, scope, scope, world.getAllReachableFacts().and(new_pred));
											    A4Solution instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), cmd, options);
												if(!instance.satisfiable()) {
													doesMatchSemantically = true;
													loc_sem.add(f);
													loc_start_or_match.add(f);
												}
												else {
													doesMatchSemantically = false;
												}
											}
											catch(Exception e3) {
												//System.out.println(expression);
												doesMatchSemantically = false;
											}
										}
									}
								}
								
								
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
								SuggestionResult suggestion_result = new SuggestionResult(suggestion, template, loc_template, doesMatchExactly, doesMatchSyntactically, doesMatchSemantically, rank, level);

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
							
							// Build metrics for when first syntactic suggestion encountered and first correct in any way
							boolean corr_encountered = false;
							
							for(int i : ranked_suggestions.keySet()) {
								for(SuggestionResult suggestion : ranked_suggestions.get(i)) {
									
									if(suggestion.doesMatchExactly) {
										total_exact++;
										total_sem++;
										syn_corr_suggetions.add(suggestion);
									}
									 
									if(suggestion.doesMatchSemantically) {
										total_sem++;	
										loc_sem.add(f);
										if(!corr_encountered) {
											first_corr_suggetions.add(suggestion);
										}
										corr_encountered = true;
									}
								}
							}
							
							//For all syntactically correct suggestions, get their length and alphabetical rankings
							for(SuggestionResult suggestion : syn_corr_suggetions) {
								int alpha = 1;
								for(String s : suggestions) {
									if(s.equals(suggestion.getSuggestion())) {
										suggestion.alpha_rank = alpha;
										break;
									}
									alpha++;
								}
								
								int len = 1;
								for(int l : suggestions_by_len.keySet()) {
									for(String s : suggestions_by_len.get(l)) {
										if(s.equals(suggestion.getSuggestion())) {
											suggestion.len_rank = len;
											break;
										}
										len++;
									}									
								}
								syn_with_ranks += suggestion.printChange() +  "\n";
							}
							
							//For all first correct suggestions, get their length and alphabetical rankings
							for(SuggestionResult suggestion : first_corr_suggetions) {
								int alpha = 1;
								for(String s : suggestions) {
									if(s.equals(suggestion.getSuggestion())) {
										suggestion.alpha_rank = alpha;
										break;
									}
									alpha++;
								}
								
								int len = 1;
								for(int l : suggestions_by_len.keySet()) {
									for(String s : suggestions_by_len.get(l)) {
										if(s.equals(suggestion.getSuggestion())) {
											suggestion.len_rank = len;
											break;
										}
										len++;
									}									
								}
								first_with_ranks += suggestion.printChange() + "\n";
							}
						}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						System.out.println(f);
					}
				    
				    //print the template based ranking order
				    String print_list_in_order = "";
				    String dir = directory + f.replaceAll(".json", "");
				    for(int i = 0; i < template_rank_ordered_sug.size(); i++) {
				    	print_list_in_order += template_rank_ordered_sug.get(i) + "\n";
				    }
				    try {
					  FileWriter myWriter = new FileWriter(dir + ".templaterank");
				      myWriter.write(print_list_in_order.trim());
				      myWriter.close();
				    } catch (IOException e) {
				      System.out.println("An error occurred.");
				      e.printStackTrace();
				    }
				    order = new ArrayList<String>();
				    lets = new HashSet<String>();
				}
			}
			 //store details on performance
			print_details += model + "," + total_exact + "," + loc_exact.size() + "," + total_start_term + "," + loc_start.size() + "," + loc_start_or_match.size() + "," + total_sem + "," + loc_sem.size() + "," + total_suggestions + "\n";
			
			syn_total += syn_with_ranks;
			first_total += first_with_ranks;
			
			
			try {
				  FileWriter myWriter = new FileWriter(result_dir + source + "_syn_rank_" + model + "s.txt");
			      myWriter.write(syn_with_ranks);
			      myWriter.close();
			      
			      myWriter = new FileWriter(result_dir + source + "_first_ranks_" + model + "s.txt");
			      myWriter.write(first_with_ranks);
			      myWriter.close();
		    } catch (IOException e) {
		      System.out.println("An error occurred.");
		      e.printStackTrace();
		    }
			
			syn_with_ranks="";
			first_with_ranks = "";
		}
		try {
			  FileWriter myWriter = new FileWriter(result_dir + source + "_syn_ranks.txt");
		      myWriter.write(syn_total);
		      myWriter.close();
		      
		      myWriter = new FileWriter(result_dir + source + "_first_ranks.txt");
		      myWriter.write(first_total);
		      myWriter.close();
		      
		      myWriter = new FileWriter(result_dir + source + "_highlevel.txt");
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
