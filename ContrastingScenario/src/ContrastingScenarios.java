import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;

import javax.swing.plaf.basic.BasicBorders;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.ErrorWarning;
import edu.mit.csail.sdg.ast.Browsable;
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
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.ast.Sig.Field;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.TranslateAlloyToKodkod;
import kodkod.solvers.PMaxSAT4JRef;
import edu.mit.csail.sdg.ast.Module;

public class ContrastingScenarios {
	

	//Order of all variables that are in scope
	static ArrayList<String> order = new ArrayList<String>();
	static HashSet<String> lets = new HashSet<String>();

	//SAT solver metrics
	static int sat_cls = 0;
	static int sat_pvars = 0;
	static int sat_vars = 0;
	
	public static void main (String [] args) throws FileNotFoundException, ParseException {
		
		//What models and suggestions to read in
		String source = "formula";
		
		//Number of suggestions to contrast
		int cap_suggestions = 5;
		//int cap_suggestions = 10;

		String [] models = {"array", "bempl", "binary-tree", "class-diagram", "classroom","classroom-fol", "classroom-rl", "courses-v1",
				"courses-v2", "c-tree", "cv", "dll", "fsm", "grade", "graph", "handshake", "lts", "nqueens", 
				"production-line-v1", "production-line-v2", "production-line-v3", "singly-linked-list", "social-media", "train-station-fol",
				"train-station-ltl", "trash-fol", "trash-ltl", "trash-rl"
		};
		
		//Establish parameters for models with them
		HashMap<String, String> parameters = new HashMap<String, String>();
		parameters.put("bempl", "r:Room,p:Person");
		parameters.put("grade", "c:Class,s:Person,a:Assignment");
		parameters.put("singly-linked-list", "l:List");

		//Where to store the results and result string to print at the end
		String result_dir = "results" + File.separator;
		String results = "";
				
		//Choose default scope
		int scope = 3;

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
			MyRep rep = new MyRep();   
			A4Options options = new A4Options();
			options.solver = PMaxSAT4JRef.INSTANCE;
			
			//Read in the base model, which is the base the compare and contrasting encodings will be appended
			String base_model = "";
		    try {
		         File myObj = new File(model_dir + model + ".als");
		         Scanner myReader = new Scanner(myObj);
		         while (myReader.hasNextLine()) { //line for line mapping
		           base_model += myReader.nextLine() + "\n";
		         }
		         myReader.close();
		    } catch (FileNotFoundException e) {
		         System.out.println("An error occurred.");
		         e.printStackTrace();
		    }
		    base_model += "\n";
			
		     
		    //Parse in the model into an Alloy object
		    CompModule world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + ".als");
			
			for(File file : listOfFiles) {
				String f = file.getName();
				if(f.contains("json")) { //The json files contains all the suggestions and all details about the completion location
					
					long start_time = System.nanoTime(); //denote overall start time
				
					File myObj = new File(directory + f);
				    Scanner myReader;
				    Object obj = null;

					myReader = new Scanner(myObj);
					while (myReader.hasNextLine()) {

						String data = myReader.nextLine();
						obj = new JSONParser().parse(data);
						
						JSONObject jo = (JSONObject) obj; 
						String incompleteLine = (String) jo.get("incompletionLine");
						String expectedCompletionLine = (String) jo.get("expectedCompletionLine");
						
						String line = incompleteLine + " " + expectedCompletionLine; //rebuild line
						String start_line = ""; //stores quantified variable declarations
						String end_line = ""; //stores end of quantified declarations
						String disj = ""; //make quantified variables disjoint to preserve contrast
						//String con_end_line = ""; 
						
						//Store all variables in scope of completion suggestion
						HashMap<String, String> vars = new HashMap<String, String>();
						
						//Add parameter variables to the Analyzer's execution environment
						if(parameters.containsKey(model)) {
							String [] params = parameters.get(model).split(",");
							for(int i = 0; i < params.length; i++) {
								String [] param = params[i].split(":");
								vars.put(param[0], param[1]);
								order.add(param[0]);
								world.addGlobal(param[0], CompUtil.parseOneExpression_fromString(world, param[1]));
							}
						}


						try {
							Expr line_expr = CompUtil.parseOneExpression_fromString(world, line);	
							vars = findVars(line_expr, vars); //Iterate over completion location, find all variables in scope. Note: not needed if directly connected to completion pipeline as these are gathered there 
							
							//For all variables in scope, build existentially quantified or let expressions to properly declare the variables
							for(int i = 0; i < order.size(); i++) {
								if(lets.contains(order.get(i))){
									world.addGlobal(order.get(i), CompUtil.parseOneExpression_fromString(world, vars.get(order.get(i))));
									start_line += " some " + order.get(i) + " : " + vars.get(order.get(i)) + " { " ;
									end_line += "}";
									//con_end_line = "} \n" + con_end_line;
								}
								else {
									world.addGlobal(order.get(i), CompUtil.parseOneExpression_fromString(world, vars.get(order.get(i))));
									start_line += " some  " + order.get(i) + " : " + vars.get(order.get(i)) + " { ";
									end_line += "}";
									//con_end_line = "} \n " + con_end_line;
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
						}
						catch(Exception e) {
							//if signature completion,  will not compile
						}
						
						//Read in the suggestions in order of the template-based ranking
						ArrayList<String> ranked_list = new ArrayList<String>();
						try {
							File file_ranked = new File(directory + f.replace(".json", ".templaterank"));
					         Scanner scanner = new Scanner(file_ranked);
					         while (scanner.hasNextLine()) {
					        	 ranked_list.add(scanner.nextLine());
					         }
					         scanner.close();
					    } catch (FileNotFoundException e) {
					         System.out.println("An error occurred.");
					         e.printStackTrace();
					    }

						//Will store the top 5 or 10 suggestions to contrast that are not built in, static Alloy sets
						ArrayList<String> suggestions = new ArrayList<String>();
						
						int num_sug = 0;
						for(int i = 0; i < ranked_list.size(); i++) {

							String suggestion = ranked_list.get(i);
							
							//default sets, values are statically defined and cannot change
							if(!(suggestion.equals("iden") || suggestion.equals("none") || suggestion.equals("univ") || suggestion.equals("String") || suggestion.equals("Int") || suggestion.equals("seq/Int") || suggestion.contains("/Ord"))) {

								//Some suggestions need refined domains due to replicated relation names in different signatures
								suggestions = check_suggestion_scope(suggestion, suggestions, model, incompleteLine, line);
						
								num_sug++;
								if(num_sug == cap_suggestions)
									break; //exit when reach cap
							}
						}
						
						//Store equivalent expressions
						HashMap<String, HashMap<String, ArrayList<String>>> equiv_classes = new HashMap<String, HashMap<String, ArrayList<String>>>();

						long start_equiv_formation_time = System.nanoTime(); //denote start time of forming equivalence classes
						
						//Loop over all suggestions under consideration
						for(String suggestion : suggestions) { 
							boolean equiv = false;
							
							Expr sug_check ;
							String arity ;
								
							//Get arity of suggestion
							if(start_line.equals("")) { //No quantifies, can pass the suggestion directly to get its arity
								sug_check = CompUtil.parseOneExpression_fromString(world, suggestion);
								arity = sug_check.type().arity() + "";
							}
							else { //At least on quantified variable declared. Need to wrap suggestion then navigate down to suggestion to get arity
								sug_check = CompUtil.parseOneExpression_fromString(world, start_line + "some " + suggestion + end_line);
								ExprQt e = (ExprQt) ((ExprUnary)sug_check).sub;
								if(order.size() > 1) {
									for(int i = 1; i < order.size(); i++) {
										ExprUnary temp = (ExprUnary) ((ExprQt)e).sub;
										 e =(ExprQt) ((ExprUnary)temp).sub;
									}
								}
								
								ExprUnary e2 = (ExprUnary) e.sub;
								ExprUnary e3 = (ExprUnary) e2.sub;
								Expr e4 =  e3.sub;
								arity = e4.type().arity() + "";
							}

							//Add arity to overall map if does not already exist
							if(!equiv_classes.containsKey(arity)) {
								equiv_classes.put(arity, new HashMap<String, ArrayList<String>>());
							}

							//Iterate over all current representative classes for the arity of the suggestion and check if it fits or forms a new class
							for(String class_representative : equiv_classes.get(arity).keySet()) {
								
								//Build comparison encoding
								String comparison = suggestion + " != " + class_representative;
								if(incompleteLine.contains("\\:")) {
									if(incompleteLine.contains("\\|"))
										comparison = incompleteLine.lastIndexOf("\\|") + comparison;
									else
										comparison = incompleteLine.lastIndexOf("\\{") + comparison;
								}
								String compare = "compare: run {" + start_line + "\n" + disj + "\n"  + comparison  + end_line + "}";
								
								try {
									  FileWriter myWriter = new FileWriter("compare_model.als");
								      myWriter.write(base_model + compare);
								      myWriter.close();

							    } catch (IOException e) {
							      System.out.println("An error occurred.");
							      e.printStackTrace();
							    }				
								
								//Parse in comparison, execute, and determine equivalence
								Module world_compare = CompUtil.parseEverything_fromFile(rep, null, "compare_model.als");			
								A4Solution comparison_instance = TranslateAlloyToKodkod.execute_command(rep, world_compare.getAllReachableSigs(), world_compare.getAllCommands().get(0), options);
								if(!comparison_instance.satisfiable()) {
									equiv = true;
									equiv_classes.get(arity).get(class_representative).add(suggestion);
								}
							}
								
							//If suggestion was not equivalent to any exist class, add it as a new one
							if(!equiv) {
								if(!(suggestion.contains(".univ"))) { //filter univ as cannot change and equals everything
									equiv_classes.get(arity).put(suggestion, new ArrayList<String>());
								}
							}
						}
						
						long end_equiv_formation_time = System.nanoTime(); //end equivalence class formation
						
						
						//Build contrasting encoding
						String contrast = "";
						
						ArrayList<String> sug_contrast = new ArrayList<String>();
						for(String arity :  equiv_classes.keySet()) {
							for(String unique : equiv_classes.get(arity).keySet()) {
								sug_contrast.add(unique);
							}
						}	
					
						for(String arity : equiv_classes.keySet()) {
							if(equiv_classes.get(arity).keySet().size() == 0 || equiv_classes.get(arity).keySet().size() == 1) {
								//Nothing to do
							}
							else {
								ArrayList<String> list = new ArrayList<String>();
								for(String unique : equiv_classes.get(arity).keySet()) {
									list.add(unique);
								}
								
								for(int i = 0; i < list.size(); i++) {
							    	 for(int j = i + 1; j < list.size(); j++) {
							    		 String part1 =  list.get(i);
							    		 String part2 =  list.get(j);	
							    		 contrast += "fact { " + start_line + "\n" + disj + "\n";
							    		contrast +=  part1 + " != " + part2 + "\n";
							    		contrast += end_line + "}\n";
							    	 }
								}
							}
						}
						
						//Store encoding
						String new_model = base_model + contrast;
						try {
							  FileWriter myWriter = new FileWriter("contrast_model.als");
						      myWriter.write(new_model );
						      myWriter.close();
						    
					    } catch (IOException e) {
					      System.out.println("An error occurred.");
					      e.printStackTrace();
					    }					
						
						//Solve encoding
						A4Solution contrast_instance = null; 
						long start_get_contrast = System.nanoTime();

						
						Module world_contrast  = CompUtil.parseEverything_fromFile(rep, null, "contrast_model.als");
				        Command c = world_contrast.getAllCommands().get(0);
				      
				        contrast_instance = TranslateAlloyToKodkod.execute_command(rep, world_contrast.getAllReachableSigs(), c, options);
				        if(!contrast_instance.satisfiable() ) {
							c = new Command(c.check, 4, c.bitwidth, c.maxseq, c.commandKeyword, c.formula);
							contrast_instance = TranslateAlloyToKodkod.execute_command(rep, world_contrast.getAllReachableSigs(), c, options);
						}
						if(!contrast_instance.satisfiable() ) {
							c = new Command(c.check, 5, c.bitwidth, c.maxseq, c.commandKeyword, c.formula);
							contrast_instance = TranslateAlloyToKodkod.execute_command(rep, world_contrast.getAllReachableSigs(), c, options);
						}	

						long end_get_contrast = System.nanoTime();
						
						//Gather and print metrics
						if(contrast_instance.satisfiable()) {
							int total_sig = 0;
							int num_sig = 0;
							int num_rel = 0;
							int num_sig_present = 0;
							int num_rel_present = 0;
							int total_rel = 0;
							
							int num_equiv_classes = 0;
							HashSet<String> evals = new HashSet<String>();
								
							for(int i = 0; i < order.size(); i++) {
								world_contrast.addGlobal(order.get(i), CompUtil.parseOneExpression_fromString(world_contrast, vars.get(order.get(i))));
							}
							order = new ArrayList<String>();

							//Determine how many were actually different
							for(String arity :  equiv_classes.keySet()) {
								if(equiv_classes.get(arity).keySet().size() == 0 || equiv_classes.get(arity).keySet().size() == 1) {
									for(String unique : equiv_classes.get(arity).keySet()) {
										num_equiv_classes++;
										Expr expr = CompUtil.parseOneExpression_fromString(world_contrast, unique);
										String eval = contrast_instance.eval(expr).toString();
										evals.add(eval);
									}
								}
								else {
									for(String unique : equiv_classes.get(arity).keySet()) {
										num_equiv_classes++;
										if(unique.contains("pos") && model.equals("train-station-ltl")) {
											unique = unique.replaceAll("pos", "(this/Train <: pos)");
										}
										Expr expr = CompUtil.parseOneExpression_fromString(world_contrast, unique);
										String eval = contrast_instance.eval(expr).toString();
										evals.add(eval);
									}
								}
							}
								
							//Gather size of scenario
							String instance = "";
							for(Sig sig : world_contrast.getAllReachableSigs()) {
								if(!sig.builtin && !sig.label.equals("ordering/Ord")) {
									total_sig++;
									String sig_size = "#" + sig.label.replaceAll("this/", "");
									Expr sig_size_expr = CompUtil.parseOneExpression_fromString(world_contrast, sig_size);
									int result_size = Integer.valueOf((String) contrast_instance.eval(sig_size_expr));
									if(result_size > 0) {
										num_sig_present++;
										num_sig += result_size;
										instance += sig.label.replaceAll("this/", "") + "=" + contrast_instance.eval(sig).toString();
									}
									
									for(Field rel : sig.getFields()) {
										total_rel++;
										String rel_size = "#" + sig.label.replaceAll("this/", "") + "." + rel.label.replaceAll("this/", "");
										Expr rel_size_expr = CompUtil.parseOneExpression_fromString(world_contrast, rel_size);
										result_size = Integer.valueOf((String) contrast_instance.eval(rel_size_expr));
										if(result_size > 0) {
											num_rel_present++;
											num_rel += result_size;
											instance += rel.label.replaceAll("this/", "") + "=" + contrast_instance.eval(rel).toString();
										}
									}
								}
							}
							
							//Different runtimes
							long runtime_total = (end_get_contrast- start_time) / 1000000;
							long runtime_contrast = (end_get_contrast - start_get_contrast) / 1000000;
							long runtime_equiv_formations = (end_equiv_formation_time - start_equiv_formation_time) / 1000000;
							results += model + "," + f + ",";
							results += evals.size() + "," + num_equiv_classes + ",";
							results += total_sig + "," + num_sig_present + "," + num_sig + "," + total_rel + "," + num_rel_present + "," + num_rel + ",";
							results += rep.pvars + "," + rep.vars + "," + rep.cls + ",";
							results += runtime_total + "," + runtime_contrast + "," + runtime_equiv_formations + "," + instance + "\n";
							break;
						}
			
						if(!contrast_instance.satisfiable()) {
							results += model + "," + f + ",NO SCENARIO,\n";
							order = new ArrayList<String>();
						}
						
						//Clean up files created
						myObj = new File("compare_model.als"); 
						myObj.delete();
						myObj = new File("contrast_model.als"); 
						myObj.delete();
					}
				}
			}
		}
		try {
		  FileWriter myWriter = new FileWriter(result_dir + source + "_contrasting_scenarios_top" + cap_suggestions + "_base.txt");
	      myWriter.write(results);
	      myWriter.close();

	    } catch (IOException e) {
	      System.out.println("An error occurred.");
	      e.printStackTrace();
	    }
		results = "";	
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
	
	//Account for relations with multiple possible domains
	public static ArrayList<String> check_suggestion_scope(String suggestion, ArrayList<String> suggestions, String model, String incompleteLine, String line){
		if(model.equals("courses-v1") || model.equals("courses-v2") ) {
			if(line.contains("all p : Person, c : Course")) {
				String sug1 = suggestion.replaceAll("projects", "(this/Person <: projects)");
				suggestions.add(sug1);
				String sug2 = suggestion.replaceAll("projects", "(this/Course <: projects)");
				suggestions.add(sug2);
			}
			else if(line.contains("all p : Person")){
				String sug1 = suggestion.replaceAll("projects", "(this/Person <: projects)");
				suggestions.add(sug1);
			}
			else if(line.contains("all c : Course")){
				String sug2 = suggestion.replaceAll("projects", "(this/Course <: projects)");
				suggestions.add(sug2);
			}
			else {
				String sug1 = suggestion.replaceAll("projects", "(this/Person <: projects)");
				suggestions.add(sug1);
				String sug2 = suggestion.replaceAll("projects", "(this/Course <: projects)");
				suggestions.add(sug2);
			}
		}
		else if(model.equals("production-line-v1")  ) {
			if(suggestion.contains("position")) {
				if(incompleteLine.contains("all c : Component")){
					String sug2 = suggestion.replaceAll("position", "(this/Component <: position)");
					suggestions.add(sug2);
				}
				else {
					String sug2 = suggestion.replaceAll("position", "(this/Robot <: position)");
					suggestions.add(sug2);
				}
			}
			else {
				 suggestions.add(suggestion);
			}
		}
		else {
			suggestions.add(suggestion);
		}
		return suggestions;
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
	
	  private static class MyRep extends A4Reporter {

	        MyRep() {
	        }


	        public int pvars;
	        public int vars;
	        public int cls;
	        
	        @Override
	        public void solve(int plength, int primaryVars, int totalVars, int clauses) {
	        	pvars = primaryVars;
	        	vars = totalVars;
	        	cls = clauses;
	        	
	        	//System.out.println("CNF generated. Primary vars: " + primaryVars + ", Total variables: " + totalVars + ", Total clauses: " + clauses);
		           
	        }

	    }
	}