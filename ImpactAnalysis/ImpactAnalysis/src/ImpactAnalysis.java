import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.ErrorWarning;
import edu.mit.csail.sdg.ast.Command;
import edu.mit.csail.sdg.ast.Expr;
import edu.mit.csail.sdg.ast.ExprUnary;
import edu.mit.csail.sdg.ast.ExprVar;
import edu.mit.csail.sdg.ast.Func;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.ast.Sig.Field;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.TranslateAlloyToKodkod;
import kodkod.solvers.PMaxSAT4JRef;
import kodkod.solvers.SAT4JRef;

public class ImpactAnalysis {
	
	public static void main (String [] args) throws FileNotFoundException, ParseException {

		//What models and suggestions to read in
		String source = "formula";

		//benchmark
		String [] models = {"array", "bempl","binary-tree", "class-diagram","classroom","classroom-fol", "classroom-rl", "courses-v1",
		"courses-v2", "c-tree", "cv", "dll", "fsm", "grade", "graph", "handshake", "lts", "nqueens",
		"production-line-v1", "production-line-v2", "production-line-v3", "singly-linked-list", "social-media", "train-station-fol",
		"train-station-ltl", "trash-fol", "trash-ltl", "trash-rl"
		};
		boolean benchmark = true;

		//large models
		/*
		String [] models = {"git", "frankervrep", "icd", "java_meta_model","modelo-alloy"};
		boolean benchmark = false;
		*/
		
		//Where to store the results and result string to print at the end
		String result_dir = "results" + File.separator;
		String result_total = "";
		
		//Choose default scope
		int scope = 3;
		
		for(String model : models) {
			String results = "";
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
			options.solver = SAT4JRef.INSTANCE;
		     
		    //Parse model
		    CompModule world;
		    
		    for(File file : listOfFiles) {
				String f = file.getName();
				if(f.contains("json")) { //The json files contains all the suggestions and all details about the completion location

					ArrayList<Parameter> parameters = new ArrayList<Parameter>();	
					//Reset world to remove any parameters stored as global variables
					if(f.contains("fixable")) { //If model had variables declared on a different line in the file, then parse the model with variable use inlined with variable declarations
						world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + "-fixable" + ".als"); 
						
						//reset parameter locations;
						parameters = getParameterLocs(world,benchmark);
					}
					else {
						world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + ".als");
						
						//reset parameter locations;
						parameters = getParameterLocs(world,benchmark);
					}
					
					//Grab the default command as a basis to build out own commands
					Command c = world.getAllCommands().get(0); 
					 
					File myObj = new File(directory + f);
				    Scanner myReader;
				    Object obj = null;

					myReader = new Scanner(myObj);
					while (myReader.hasNextLine()) {
						
						String data = myReader.nextLine();
						obj = new JSONParser().parse(data);
							
						JSONObject jo = (JSONObject) obj; 
						String incompleteLine = (String) jo.get("incompletionLine"); //Get everything up to the completion location
						JSONArray evaluationResult = (JSONArray) jo.get("evaluationResult"); //Get the list of completion suggestions
						
						incompleteLine = incompleteLine.replaceAll("\\(","");
						incompleteLine = incompleteLine.replaceAll("\\)","");
	
						
						//Add parameter variables to the Analyzer's execution environment
						long line_number = (Long) jo.get("line");
						
						for(Parameter p : parameters) {
							if(line_number >= p.start_line && line_number <= p.end_line) {
								world.addGlobal(p.variable, CompUtil.parseOneExpression_fromString(world, p.type));
							}
						}

						//Iterate over all suggestions for the completion location
						for(int r = 0; r < evaluationResult.size(); r++) {
							
							JSONObject result = (JSONObject) evaluationResult.get(r);
							String suggestion = (String) result.get("suggestion"); //grab suggestion
							String new_state_string = incompleteLine + " " + suggestion; //build "after" state
								
							String [] temp = incompleteLine.split(" ");
							Expr inital_state = null;
							String intial_state_string = ""; //"set up string to build "before" state
								
							long start = System.nanoTime(); //begin runtime calculation for impact analysis 
								
							//check to see if the completion is a valid formula - if not, cannot provide an analysis 
							Expr can_execute_suggestion = null;
							A4Solution can_execute_inst = null;
							try {
								can_execute_suggestion = CompUtil.parseOneExpression_fromString(world, new_state_string);
						
								Command can_execute = new Command(false, scope, scope, scope, c.commandKeyword, can_execute_suggestion);
								can_execute_inst = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), can_execute, options);
							
							}
							catch (Exception e) {
							
							}
								
							//Continue if we can provide an impact analysis 
							if(can_execute_inst != null) {
	
								//Discover the previously compilable state. Truncate repeatedly
								for(int i = 0; i < temp.length; i++) {
									String attempt = "";
									for(int j = 0; j < temp.length - i; j++ ) {
										attempt += temp[j] + " ";
									}
									try {
										inital_state = CompUtil.parseOneExpression_fromString(world, attempt);
										Command can_execute = new Command(false, scope, scope, scope, c.commandKeyword, inital_state);
										can_execute_inst = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), can_execute, options);
										
										intial_state_string = attempt;
										break;
									}
									catch(Exception e) {
									}
								}
								//If never found something that compiled, the before state is the empty predicate
								if(inital_state == null) {
									intial_state_string = "";
								}
									
								//Build expression to target minimum instance
								A4Solution min = null;
								if(benchmark) {
									String small = "";
									String and = "";
									for(Sig sig : world.getAllReachableSigs()) {
										if(!sig.builtin && !sig.label.contains("Ord")) {
											if(sig.isOne != null) {
												small += and + "one " + sig.label.replaceAll("this/","") ;
											}
											else {
												small += and + "no " + sig.label.replaceAll("this/","") ;
											}
											and = " and ";
										}
									}
									Expr empty_expr = CompUtil.parseOneExpression_fromString(world, small);
									Command empty = new Command(false, scope, scope, scope, c.commandKeyword, empty_expr);
									min = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), empty, options);
								}
								else {
									min = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), world.getAllCommands().get(1), options);
								}
									
								A4Solution target = null;


								//Set up impact command A and !B
								Expr a_and_not_b_expr = CompUtil.parseOneExpression_fromString(world, "{" + intial_state_string + "} and !{" + new_state_string +"}");
								Command a_and_not_b = new Command(false, scope, scope, scope, c.commandKeyword, a_and_not_b_expr);
								A4Solution a_and_b_not_instance;
									
								//Target a minimal solution
								try {
									a_and_b_not_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), a_and_not_b, options, min);
								}
								catch (Exception e1) { //Otherwise grab the first solution
									a_and_b_not_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), a_and_not_b, options);
								}
							
								if(a_and_b_not_instance.satisfiable()) { //If A and !B has a solution, make the target moving forward
									target = a_and_b_not_instance;
								}
									
								//Set up impact command !A and B
								Expr not_a_and_b_expr = CompUtil.parseOneExpression_fromString(world, "!{" + intial_state_string + "} and {" + new_state_string +"}");
								Command not_a_and_b =  new Command(false, scope, scope, scope, c.commandKeyword, not_a_and_b_expr);
								A4Solution not_a_and_b_instance;
									
								if(target != null) { //Target previously satisfiable impact command solution
									try {
										not_a_and_b_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), not_a_and_b, options, target);
									}
									catch (Exception e) {
										not_a_and_b_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), not_a_and_b, options);
									}	
								}
								else { //If no previous impact command was satisfiable, target a minimal solution
									try {
										not_a_and_b_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), not_a_and_b, options, min);
									}
									catch (Exception e1) {
										not_a_and_b_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), not_a_and_b, options);
									}
																			
									if(not_a_and_b_instance.satisfiable()) { //If !A and B has a solution, make the target moving forward
										target = not_a_and_b_instance;
									}
								}
									
								//Set up impact command A and B
								Expr a_and_b_expr = CompUtil.parseOneExpression_fromString(world, "{" + intial_state_string + "} and {" + new_state_string +"}");
								Command a_and_b =  new Command(false, scope, scope, scope, c.commandKeyword, a_and_b_expr);
								A4Solution a_and_b_instance = null;
								
								if(target != null) { //Target previously satisfiable impact command solution
									try {
										a_and_b_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), a_and_b, options, target);
									}
									catch (Exception e) {											
										a_and_b_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), a_and_b, options);
									}
								}
								else { 	 //If no previous impact command was satisfiable, target a minimal solution
									try {
										a_and_b_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), a_and_b, options, min);
									}
									catch (Exception e1) {
										a_and_b_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), a_and_b, options);
									}					
										
									if(a_and_b_instance.satisfiable()) {  //If A and B has a solution, make the target moving forward
										target = a_and_b_instance;
									}
								}
								
								//Set up impact command !A and !B	
								Expr not_a_and_not_b_expr = CompUtil.parseOneExpression_fromString(world, "!{" + intial_state_string + "} and !{" + new_state_string +"}");
								Command not_a_and_not_b = new Command(false, scope, scope, scope, c.commandKeyword, not_a_and_not_b_expr);
								A4Solution not_a_and_b_not_instance;
									
								if(target != null) { //Target previously satisfiable impact command solution
									try {
										not_a_and_b_not_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), not_a_and_not_b, options, target);
									}
									catch (Exception e) {
										
										not_a_and_b_not_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), not_a_and_not_b, options);
									}
								}
								else { ///If no previous impact command was satisfiable, target a minimal solution
									try {
										not_a_and_b_not_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), not_a_and_not_b, options, min);
									}
									catch (Exception e1) {
										not_a_and_b_not_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), not_a_and_not_b, options);
									}	
								}
									
								long end = System.nanoTime(); //end of impact analysis execution
								
								//Gather and print results to csv file for analysis
								results += model + "," + f + "," + suggestion + ",";
								results += a_and_b_instance.satisfiable() + "," + a_and_b_not_instance.satisfiable() + "," + not_a_and_b_instance.satisfiable() + "," + not_a_and_b_not_instance.satisfiable() +",";
								
								results += diff(a_and_b_instance,a_and_b_not_instance,world);
								results += diff(a_and_b_instance,not_a_and_b_instance,world);
								results += diff(a_and_b_instance,not_a_and_b_not_instance,world);
								
								results += diff(a_and_b_not_instance,not_a_and_b_instance,world);
								results += diff(a_and_b_not_instance,not_a_and_b_not_instance,world);
								
								results += diff(not_a_and_b_instance,not_a_and_b_not_instance,world);	
								
								results += (end - start)/1000000;
								results += "\n";
							}
						}
					}
				}
		     }
		    result_total += results;
		    try {
				  FileWriter myWriter = new FileWriter(result_dir + source + "_impact_target_and_min_" + model + ".txt");
			      myWriter.write(results);
			      myWriter.close();
		    } catch (IOException e) {
		      System.out.println("An error occurred.");
		      e.printStackTrace();
		    }
		}
		  try {
			  FileWriter myWriter = new FileWriter(result_dir + source + "_impact_target_and_min.txt");
		      myWriter.write(result_total);
		      myWriter.close();
	    } catch (IOException e) {
	      System.out.println("An error occurred.");
	      e.printStackTrace();
	    }
		
	}
	
	
	//Calculate difference between instances as the number of atoms/relations in one but not the other
	public static String diff (A4Solution one, A4Solution two, CompModule world) {
		String result = "";
		
		if(!one.satisfiable() || !two.satisfiable())
			return ",";
		
		HashMap<String, HashSet<String>> inOne = new HashMap<String,HashSet<String>>();
		HashMap<String,HashSet<String>> inTwo = new HashMap<String,HashSet<String>>();
		int count = 0;
		
		for(Sig sig : world.getAllReachableSigs()) {
			if(!sig.builtin) {
				String elements = one.eval(sig).toString();
				elements = elements.replaceAll("\\{", "");
				elements = elements.replaceAll("\\}", "");
				String [] temp = elements.split(",");
				inOne.put(sig.label, new HashSet<String>());
				for(String s : temp) {
					inOne.get(sig.label).add(s);
				}
					
				
				elements = two.eval(sig).toString();
				elements = elements.replaceAll("\\{", "");
				elements = elements.replaceAll("\\}", "");
				temp = elements.split(",");
				inTwo.put(sig.label, new HashSet<String>());
				for(String s : temp) {
					inTwo.get(sig.label).add(s);
				}
				
				for(Field rel : sig.getFields()) {
					elements = one.eval(rel).toString();
					elements = elements.replaceAll("\\{", "");
					elements = elements.replaceAll("\\}", "");
					temp = elements.split(",");
					inOne.put(rel.label, new HashSet<String>());
					for(String s : temp) {
						inOne.get(rel.label).add(s);
					}
					
					elements = two.eval(rel).toString();
					elements = elements.replaceAll("\\{", "");
					elements = elements.replaceAll("\\}", "");
					temp = elements.split(",");
					inTwo.put(rel.label, new HashSet<String>());
					for(String s : temp) {
						inTwo.get(rel.label).add(s);
					}
				}
			}
		}
		
		for(String set : inOne.keySet()) {
			for(String atom : inOne.get(set)) {
				if(!inTwo.get(set).contains(atom))
					count++;
			}
		}
		
		for(String set : inTwo.keySet()) {
			for(String atom : inTwo.get(set)) {
				if(!inOne.get(set).contains(atom))
					count++;
			}
		}
		return count + ",";
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
	
	public static ArrayList<Parameter> getParameterLocs(CompModule world, boolean benchmark){
		ArrayList<Parameter> parameters = new ArrayList<Parameter>();
	    for(Func pred : world.getAllFunc()) {
	    	for(ExprVar ev : pred.params()) {
	    		if(benchmark)
	    			parameters.add(new Parameter(ev.label, ev.type().toString(), pred.pos.y, pred.pos.y2));
	    		else
	    			parameters.add(new Parameter(ev.label, ev.type().toString(), pred.pos.y-2, pred.pos.y2-2));
	    	}
	    } 
	    return parameters;
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
        }
    }

}
