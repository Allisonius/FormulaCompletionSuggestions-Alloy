package RankPriority;

public class ExtendsOp {
	
	int highest_ranked_template = 1;

	public int priorityLevel(String incompleteTerm, String template) {
		
		incompleteTerm = incompleteTerm.replaceAll("\\~", "");
		incompleteTerm = incompleteTerm.replaceAll("\\*", "");
		incompleteTerm = incompleteTerm.replaceAll("\\^", "");

		if(incompleteTerm.equals("SIGNATURE")) {
			if(template.equals("SIGNATURE")) {
				return 1;
			}
		}
		//rank built in set features last
		if(template.equals("CONSTANT")) {
			return Integer.MAX_VALUE;
		}
		if(template.equals("OTHER")) {
			return Integer.MAX_VALUE;
		}

		//Priority: number of joins, favor transpose, then closure, then rclosures
		String [] num_joins = template.split("\\.");
		int closures = countClosure(template);
		int rclosures = countRClosure(template);
		int transposes = countTranspose(template);
		
		int ops = closures + rclosures + transposes;
		
		int rank = highest_ranked_template + 1 + (num_joins.length * 1000);
		
		rank += ops * 10000;
		rank += transposes;
		rank += closures * 10;
		rank += rclosures * 100;
		
		return rank;
			
		//else {
		//	throw new java.lang.RuntimeException("Not found: " + incompleteTerm);
		//}
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
