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
import edu.mit.csail.sdg.ast.Func;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.ast.Sig.Field;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.TranslateAlloyToKodkod;
import kodkod.solvers.PMaxSAT4JRef;
import edu.mit.csail.sdg.ast.Module;

public class ContrastingScenario_WithTarget {
	
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
				
		// benchmark models
		/**/
		String [] models = {"array", "bempl", "binary-tree", "class-diagram", "classroom","classroom-fol", "classroom-rl", "courses-v1",
				"courses-v2", "c-tree", "cv", "dll", "fsm", "grade", "graph", "handshake", "lts", "nqueens", 
				"production-line-v1", "production-line-v2", "production-line-v3", "singly-linked-list", "social-media", "train-station-fol",
				"train-station-ltl", "trash-fol", "trash-ltl", "trash-rl"
		};
		boolean benchmark = true;

		//large models
		/*String [] models = {"frankervrep", "git", "icd", "java_meta_model", "modelo-alloy","hamsters","kafka","ledger","lib"};
		boolean benchmark = false;*/
		
		//Where to store the results and result string to print at the end
		String result_dir = "results" + File.separator;
		String results = "";
		String combined_results = "";		
		
		//Choose default scope
		int scope = 3;	

		for(String model : models) {
			
			if(!benchmark){
				scope = 4;
			}

			//Build the relevant directory locations.
			//Directory where the json file is stored from the completion suggestion generator
			String directory = "test-results" + File.separator + source + File.separator + "multi_term" + File.separator + model + File.separator;
			//Location where the model under consideration is stored
			String model_dir = "models" + File.separator;
			
			//Gather all the files produced by the completion suggestion framework
			File folder = new File(directory);
			File[] listOfFiles = folder.listFiles();

			//Configure objects for Analyzer command executions
			MyRep rep = new MyRep();   
			A4Options options = new A4Options();
			options.solver = PMaxSAT4JRef.INSTANCE;
			
			//Read in the base model, which is the base the compare and contrasting encodings will be appended
			String base_model = "";
  
			 //Stores the model as an Alloy object
		    CompModule world;
		    
		    //Locate all parameters and then line range
		    ArrayList<Parameter> parameters = new ArrayList<Parameter>();
		    
			for(File file : listOfFiles) {
				String f = file.getName();
				if(f.contains("json") ) { //The json files contains all the suggestions and all details about the completion location
				
					//Reset world to remove any parameters stored as global variables
					if(f.contains("fixable")) { //If model had variables declared on a different line in the file, then parse the model with variable use inlined with variable declarations
						world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + "-fixable" + ".als"); 
						
						//reset parameter locations and base model helper data
						parameters = getParameterLocs(world, benchmark);
					    base_model = getBase(model_dir,model+ "-fixable");
					}
					else {
						world = CompUtil.parseEverything_fromFile(rep, null, model_dir + model + ".als");
						
						//reset parameter locations
						parameters = getParameterLocs(world, benchmark);
					    base_model = getBase(model_dir,model);
					}
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
						String expectedCompletionWord = (String) jo.get("expectedCompletionWord");
						String expectedCompletionLine = (String) jo.get("expectedCompletionLine");
						
						expectedCompletionLine = expectedCompletionLine.trim();
						expectedCompletionLine = clean_expectedCompletionLine(expectedCompletionLine);
						
						incompleteLine = clean_incompleteLine(incompleteLine);
						
						String line = incompleteLine + " " + expectedCompletionLine; //rebuild line
						String start_line = ""; //stores quantified variable declarations
						String end_line = ""; //stores end of quantified declarations
						String disj = ""; //make quantified variables disjoint to preserve contrast
						String params_inline_start = "";
						String params_inline_end = "";
						long line_number = (Long) jo.get("line");
						
						if(line.contains("}") && !line.contains("{")) {
							line = line.substring(0, line.lastIndexOf("}"));
						}
						
						//Store all variables in scope of completion suggestion
						HashMap<String, String> vars = new HashMap<String, String>();
						
						//Add parameter variables to the Analyzer's execution environment
						for(Parameter p : parameters) {
							if(line_number >= p.start_line && line_number <= p.end_line) {
								vars.put(p.variable, p.type);
								order.add(p.variable);
								world.addGlobal(p.variable, CompUtil.parseOneExpression_fromString(world, p.type));
								params_inline_start += "some " + p.variable + " : " + p.type + " { ";
								params_inline_end += "}";
							}
						}

						//Some completion locations are inlined with the declaration of the fact/pred/func - remove these declarations for we have a standalone compilable formula
						//Check for and remove inline declarations
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
						
						if(line.startsWith("fact ")  && line.contains("}")) { // inlined fact
							line = line.substring(line.indexOf("{") + 1);
							line = line.substring(0, line.lastIndexOf("}"));
						}
						
						if(line.startsWith("fun ")  && line.contains("}")) { // inlined fact
							line = line.substring(line.indexOf("{") + 1);
							line = line.substring(0, line.lastIndexOf("}"));
						}
						
						try { //Compile line, get all variables declared in let or quantified formulas unless completion is located in signature/relation 
							Expr line_expr = null;
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
								suggestions = check_suggestion_scope(suggestion, suggestions, model, incompleteLine, line, expectedCompletionWord, expectedCompletionLine, params_inline_start, params_inline_end, start_line, world);
						
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
								
							if(!suggestion.equals("")) {
							//Get arity of suggestion
							if(start_line.equals("")) { //No quantifies, can pass the suggestion directly to get its arity
								System.out.println(model + " - " + suggestion + " - " + f);
								sug_check = CompUtil.parseOneExpression_fromString(world, suggestion);
								arity = sug_check.type().arity() + "";
							}
							else { //At least on quantified variable declared. Need to wrap suggestion then navigate down to suggestion to get arity
								//System.out.println(start_line + "some " + suggestion + end_line);
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
								
								
								String comparison = suggestion + " != " + class_representative;
								if(incompleteLine.contains("\\:")) {
									if(incompleteLine.contains("\\|"))
										comparison = incompleteLine.lastIndexOf("\\|") + comparison;
									else
										comparison = incompleteLine.lastIndexOf("\\{") + comparison;
								}
								String compare = "compare: run {" + start_line + "\n" + disj + "\n"  + comparison  + end_line + "}";
								//String compare = "{" + start_line + "\n" + disj + "\n"  + comparison  + end_line + "}";
								
								try {
									  FileWriter myWriter = new FileWriter("compare_model.als");
								      myWriter.write(base_model + compare);
								      myWriter.close();

							    } catch (IOException e) {
							      System.out.println("An error occurred.");
							      e.printStackTrace();
							    }				
								
								//Parse in comparison, execute, and determine equivalence
								//System.out.println(base_model + compare);
								
								A4Solution comparison_instance = null;
								try {
									compare = "{" + start_line + "\n" + disj + "\n"  + comparison  + end_line + "}";
									Expr compare_pred = CompUtil.parseOneExpression_fromString(world, compare); //world.getAllCommands().get(0).commandKeyword,
									
									Command compare_cmd = new Command(false, scope, scope, scope, world.getAllCommands().get(0).commandKeyword,  world.getAllReachableFacts().and(compare_pred));
									comparison_instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), compare_cmd, options);
								}
								catch(Exception e) {
									Module world_compare = CompUtil.parseEverything_fromFile(rep, null, "compare_model.als");		
									Command cmd = world_compare.getAllCommands().get(0);
									for(Command c : world_compare.getAllCommands()) {
										if(c.label.equals("compare"))
											cmd = c;
									}
									comparison_instance = TranslateAlloyToKodkod.execute_command(rep, world_compare.getAllReachableSigs(),cmd, options);
								}

								if(!comparison_instance.satisfiable()) {
									equiv = true;
									equiv_classes.get(arity).get(class_representative).add(suggestion);
								}
							}
								
							//If suggestion was not equivalent to any exist class, add it as a new one
							if(!equiv) {
								if(!(suggestion.contains(".univ"))) { //filter univ as cannot change and equals everything
									equiv_classes.get(arity).put(suggestion, new ArrayList<String>());
									num_sug++;
								}
							}
						}
						}
						
						long end_equiv_formation_time = System.nanoTime(); //end equivalence class formation
	
						//Get target instance: smallest instance possible
						A4Solution minInstance = null;
						if(benchmark) {
							//Build expression to target minimum instance
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

							Expr empty_pred = CompUtil.parseOneExpression_fromString(world, small); //world.getAllCommands().get(0).commandKeyword,
							Command empty_cmd = new Command(false, scope, -1, -1, world.getAllCommands().get(0).commandKeyword,  world.getAllReachableFacts().and(empty_pred));
							minInstance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), empty_cmd, options);

						}
						else {
							minInstance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), world.getAllCommands().get(0), options);
						}
							
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
							    		 contrast += "fact { " + params_inline_start + start_line + "\n" + disj + "\n";
							    		contrast +=  part1 + " != " + part2 + "\n";
							    		contrast += end_line + params_inline_end + "}\n";
							    	 }
								}
							}
						}
						
						//Store encoding
						String new_model = base_model + contrast + "\ncontrast: run {}\n";
						//System.out.println(new_model);
						
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
				
				        //Command c = world_contrast.getAllCommands().get(0);
						Command c = world_contrast.getAllCommands().get(0);
						for(Command cmd : world_contrast.getAllCommands()) {
							if(cmd.label.equals("contrast")) {
								c = cmd;
							}
						}
						c = new Command(false, scope , c.bitwidth, c.maxseq, c.commandKeyword,  world_contrast.getAllReachableFacts().and(c.formula));
						
						if(minInstance.satisfiable()) { //Target minimal if satisfiable
							contrast_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world_contrast.getAllReachableSigs(), c, options, minInstance);
							if(!contrast_instance.satisfiable() ) { // try increasing scope by one
								c = new Command(c.check, scope + 1, c.bitwidth, c.maxseq, c.commandKeyword, c.formula);
								contrast_instance = TranslateAlloyToKodkod.execute_command_with_target(rep, world_contrast.getAllReachableSigs(), c, options, minInstance);
							}						
						}
						else { //If no minimal found, just execute the encoding
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
							
							//Gather size of scenario
							String instance = "";
							for(Sig sig : world_contrast.getAllReachableSigs()) {
								if(!sig.builtin && !sig.label.contains("/Ord")) {
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
							
							//Different runtimes
							long runtime_total = (end_get_contrast- start_time) / 1000000;
							long runtime_contrast = (end_get_contrast - start_get_contrast) / 1000000;
							long runtime_equiv_formations = (end_equiv_formation_time - start_equiv_formation_time) / 1000000;
							results += model + "," + f + ",";
							results += evals.size() + "," + num_equiv_classes + ",";
							results += total_sig + "," + num_sig_present + "," + num_sig + "," + total_rel + "," + num_rel_present + "," + num_rel + ",";
							results += rep.pvars + "," + rep.vars + "," + rep.cls + ",";
							results += runtime_total + "," + runtime_contrast + "," + runtime_equiv_formations  + "\n"; //+ "," + instance
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
			try {
				  FileWriter myWriter = new FileWriter(result_dir + source + "_contrasting_scenarios_top" + cap_suggestions + "_with_target_" + model + ".txt");
			      myWriter.write(results);
			      myWriter.close();

			    } catch (IOException e) {
			      System.out.println("An error occurred.");
			      e.printStackTrace();
			    }
				//combined_results += results;
				results = "";	
		}
		try {
		  FileWriter myWriter = new FileWriter(result_dir + source + "_contrasting_scenarios_top" + cap_suggestions + "_with_target.txt");
	      myWriter.write(combined_results);
	      myWriter.close();

	    } catch (IOException e) {
	      System.out.println("An error occurred.");
	      e.printStackTrace();
	    }
		combined_results = "";	
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
	
	//Account for relations with multiple possible domains
	public static ArrayList<String> check_suggestion_scope(String suggestion, ArrayList<String> suggestions, String model, String incompleteLine, String line, String expectedTerm, String expectedCompletionLine, String param_start, String param_end, String start_line, CompModule world){
		
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
		else if(model.equals("git-fixable")  ) {
			String newLine = "";
			if(suggestion.contains("content")) {
				
				try {
					String sug2 = suggestion.replaceAll("content", "(this/File <: content)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("content", "(this/Tree <: content)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("HEAD")) {
				
				
				try {
					String sug2 = suggestion.replaceAll("HEAD", "(this/Name <: HEAD)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("git")  ) {
			String newLine = "";
			if(suggestion.contains("content")) {
				
				try {
					String sug2 = suggestion.replaceAll("content", "(this/File <: content)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("content", "(this/Tree <: content)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("HEAD")) {
				
				
				try {
					String sug2 = suggestion.replaceAll("HEAD", "(this/Name <: HEAD)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("icd")  ) {
			String newLine = "";
			if(suggestion.contains("joules_to_deliver")) {
				
				try {
					String sug2 = suggestion.replaceAll("joules_to_deliver", "(this/ChangeSettingsMessage <: joules_to_deliver)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("joules_to_deliver", "(this/State <: joules_to_deliver)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("java_meta_model_fixable")  ) {
			String newLine = "";
			if(suggestion.contains("id")) {
				
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Class <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Field <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Method <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/MethodInvocation <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("acc")) {
				
				try {
					String sug2 = suggestion.replaceAll("acc", "(this/Field <: acc)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("acc", "(this/Method <: acc)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("java_meta_model")  ) {
			String newLine = "";
			if(suggestion.contains("id")) {
				
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Class <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Field <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Method <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/MethodInvocation <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("acc")) {
				
				try {
					String sug2 = suggestion.replaceAll("acc", "(this/Field <: acc)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("acc", "(this/Method <: acc)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("modelo-alloy")  ) {
			String newLine = "";
			if(suggestion.contains("DayValue")) {
				
				try {
					String sug2 = suggestion.replaceAll("DayValue", "(this/Date <: DayValue)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("DayValue", "(this/currentDate <: DayValue)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("modelo-alloy-fixables")  ) {
			String newLine = "";
			if(suggestion.contains("DayValue")) {
				
				try {
					String sug2 = suggestion.replaceAll("DayValue", "(this/Date <: DayValue)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("DayValue", "(this/currentDate <: DayValue)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("random_ski_jumping")  ) {
			String newLine = "";
			if(suggestion.contains("teams")) {
				
				try {
					String sug2 = suggestion.replaceAll("teams", "(this/Event <: teams)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("teams", "(this/Performance <: teams)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("smart-home")  ) {
			String newLine = "";
			if(suggestion.contains("id")) {
				
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Home <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Room <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Device <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("id", "(this/Sensor <: id)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("state")) {
				try {
					String sug2 = suggestion.replaceAll("state", "(this/Room <: state)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("state", "(this/Device <: state)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("state", "(this/Sensor <: state)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(start_line.contains("home")) {
				try {
					String sug2 = suggestion.replaceAll("home", "(this/OutdoorDevice <: home)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion;
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("statecoverage")  ) {
			String newLine = "";

			if(suggestion.contains("from")) {
				try {
					String sug2 = suggestion.replaceAll("from", "(this/Transition <: from)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("from", "(this/Step <: from)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}

			}
			else if (suggestion.contains("to")) {
				try {
					String sug2 = suggestion.replaceAll("to", "(this/Transition <: to)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("to", "(this/Step <: to)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}

			}
			
			else {
				suggestions.add(suggestion);
			}
		}
		else if(model.equals("ledger")  ) {
			String newLine = "";
			if(suggestion.contains("next")) {
				try {
					String sug2 = suggestion.replaceAll("next", "(this//State <: next)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("prev")) {
				try {
					String sug2 = suggestion.replaceAll("prev", "(this/Hash <: prev)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("prev", "(this/BlockRec <: prev)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
			}
			else if(suggestion.contains("meta")) {
				try {
					String sug2 = suggestion.replaceAll("meta", "(this/Transaction <: meta)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, newLine);
					suggestions.add(sug2);
				}
				catch(Exception e) {
				}
				try {
					String sug2 = suggestion.replaceAll("meta", "(this/BlockRec <: meta)");
					newLine = param_start + incompleteLine + sug2 + expectedCompletionLine.substring(expectedTerm.length()) + param_end;
					CompUtil.parseOneExpression_fromString(world, sug2);
					suggestions.add(sug2);
				}
				catch(Exception e) {
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
	
	public static String getBase(String model_dir, String model) {
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
	    return base_model;
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
	        	
	        	//System.out.println("CNF generated. Primary vars: " + primaryVars + ", Total variables: " + totalVars + ", Total clauses: " + clauses);
		           
	        }

	    }
}
