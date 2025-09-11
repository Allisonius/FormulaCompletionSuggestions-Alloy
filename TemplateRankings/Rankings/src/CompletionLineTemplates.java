import java.util.ArrayList;
import java.util.HashMap;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.ErrorWarning;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.ast.Sig.Field;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;

public class CompletionLineTemplates {
	
	HashMap<String, ArrayList<String>> signatures;
	HashMap<String, ArrayList<String>> relations;
	
	public CompletionLineTemplates(String model, String dir) {
		signatures = new HashMap<String, ArrayList<String>>();
		relations = new HashMap<String, ArrayList<String>>();
		
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
	     CompModule world = CompUtil.parseEverything_fromFile(rep, null, dir + model + ".als");
	     
	     signatures.put(model, new ArrayList<String>());
	     relations.put(model, new ArrayList<String>());
	     for(Sig sig : world.getAllReachableSigs()) {
	    	 String name = sig.label.replaceFirst("this/", "");
	    	 signatures.get(model).add(name);
	    	 for(Field rel : sig.getFields()) {
	    		 name = rel.label.replaceFirst("this/", "");
	    		 relations.get(model).add(name);
	    	 }
	     }
	}
	
	public String cleanLine(String line, String term, String model) {
		
		//prune fillers
		line = line.replaceAll("\\(", "");
		line = line.replaceAll("\\)", "");
		
		//prune off completion term
		line = line.substring(0, line.length() - term.trim().length());
		
		//Get last term of completion line
		String [] split = line.split(" ");
		String loc_template = split[split.length - 1];
		if(loc_template.contains(":")) {
			loc_template = loc_template.substring(loc_template.indexOf(":") + 1);
		}
		if(loc_template.contains("|")) {
			loc_template = loc_template.substring(0,loc_template.indexOf("|"));
		}
		
		//replace detailed content with template information - signatures, relations
		for(String rel : relations.get(model)) {
			loc_template = loc_template.replaceAll(rel, "RELATION");
		}
		for(String sig : signatures.get(model)) {
			loc_template = loc_template.replaceAll(sig, "SIGNATURE");
		}
		
		//replace detailed content with template information - variables
		split = loc_template.split("\\.");
		loc_template = "";
		String join = "";

		for(int i = 0; i < split.length; i++) {
			if(split[i].contains("SIGNATURE") || split[i].contains("RELATION")) {
				loc_template += join + split[i];
			}
			else if(split[i].contains("iden") || split[i].contains("none") || split[i].contains("Int") || split[i].contains("univ") ) {
				loc_template += join + "CONSTANT";
			}
			else {
				loc_template += join + "VARIABLE";
			}
			join = ".";
		}
		
		if(loc_template.startsWith("^") || loc_template.startsWith("~") || loc_template.startsWith("*")) {
			loc_template = loc_template.substring(1);
		}

		return loc_template;
	}

}
