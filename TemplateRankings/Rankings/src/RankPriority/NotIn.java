package RankPriority;

public class NotIn {
	
	int highest_ranked_template = 20;

	public int priorityLevel(String incompleteTerm, String template) {
		
		incompleteTerm = incompleteTerm.replaceAll("\\~", "");
		incompleteTerm = incompleteTerm.replaceAll("\\*", "");
		incompleteTerm = incompleteTerm.replaceAll("\\^", "");

		if(incompleteTerm.equals("VARIABLE")) {
			if(template.equals("VARIABLE.RELATION")) {
				return 1;
			}
			else if(template.equals("VARIABLE.RELATION.VARIABLE")) {
				return 2;
			}
			else if(template.equals("VARIABLE")) {
				return 3;
			}
			else if(template.equals("VARIABLE.^RELATION")) {
				return 4;
			}
			else if(template.equals("VARIABLE.RELATION.RELATION")) {
				return 5;
			}
			else if(template.equals("SIGNATURE")) {
				return 6;
			}
			if(template.equals("SIGNATURE.RELATION")) {
				return 7;
			}
			else if(template.equals("VARIABLE.VARIABLE.RELATION")) {
				return 8;
			}
			else if(template.equals("SIGNATURE.RELATION.VARIABLE")) {
				return 8;
			}
			else if(template.equals("VARIABLE.RELATION.VARIABLE.RELATION")) {
				return 8;
			}
			else if(template.equals("RELATION.VARIABLE")) {
				return 9;
			}
			
		}
		else if(incompleteTerm.equals("VARIABLE.RELATION")) {
			if(template.equals("SIGNATURE")) {
				return 1;
			}
			else if(template.equals("VARIABLE.RELATION")) {
				return 2;
			}
		}
		else if(incompleteTerm.equals("VARIABLE->VARIABLE")) {
			if(template.equals("VARIABLE.RELATION")) {
				return 1;
			}
			else if(template.equals("RELATION")) {
				return 2;
			}
			else if(template.equals("VARIABLE")) {
				return 2;
			}
			else if(template.equals("^VARIABLE.RELATION")) {
				return 3;
			}
		}
		
		if(template.equals("SIGNATURE")) {
			return 11;
		}
		if(template.equals("VARIABLE")) {
			return 14;
		}
		if(template.equals("RELATION")) {
			return 13;
		}
		/*
		if(template.equals("SIGNATURE.RELATION")) {
			return 12;
		}
		if(template.equals("VARIABLE.RELATION")) {
			return 12;
		}
		if(template.startsWith("SIGNATURE.RELATION")) {
			return 14;
		}
		if(template.startsWith("VARIABLE.RELATION")) {
			return 14;
		}
		*/
		
		//Priority: number of joins, favor transpose, then closure, then rclosures
		String [] num_joins = template.split("\\.");
		int closures = countClosure(template);
		int rclosures = countRClosure(template);
		int transposes = countTranspose(template);
		
		int ops = closures + rclosures + transposes;
		
		int vars = 0;
		int rels = 0;
		int sigs = 0;
		if(template.contains("VARIABLE")) {
			String temp [] = template.split("VARIABLE");
			vars += temp.length;
		}
		if(template.contains("SIGNATURE")) {
			String temp [] = template.split("SIGNATURE");
			vars += temp.length;
		}
		if(template.contains("RELATION")) {
			String temp [] = template.split("RELATION");
			vars += temp.length;
		}
		
		int rank = highest_ranked_template + 1 + + rels + (num_joins.length * 100000);
		
		rank += ops * 10000;
		rank += transposes * 10;
		rank += closures * 100;
		rank += rclosures * 1000;
		
		return rank;
	}
	
	public int countClosure(String suggestion) {
		int num = 0;
		
		for(int i = 0; i < suggestion.length(); i++) {
			if(suggestion.charAt(i) == '^') {
				num++;
			}
		}
		
		return num;
	}
	
	public int countRClosure(String suggestion) {
		int num = 0;
		
		for(int i = 0; i < suggestion.length(); i++) {
			if(suggestion.charAt(i) == '*') {
				num++;
			}
		}
		
		return num;
	}
	
	public int countTranspose(String suggestion) {
		int num = 0;
		
		for(int i = 0; i < suggestion.length(); i++) {
			if(suggestion.charAt(i) == '~') {
				num++;
			}
		}
		
		return num;
	}
}
