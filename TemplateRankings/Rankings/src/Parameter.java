
public class Parameter {
	public String variable;
	public String type;
	public int start_line;
	public int end_line;
	
	public Parameter(String variable, String type, int start_line, int end_line) {
		this.variable = variable;
		
		type = type.replaceAll("this/", "");
		type = type.replaceAll("\\{","");
		type = type.replaceAll("\\}","");
		if(type.contains(",")) {
			String [] temp = type.split(",");
			String union = "";
			type = "";
			for(String s : temp) {
				type += union + s;
				union = " + ";
			}
		}
		
		this.type = type;	
		this.start_line = start_line;
		this.end_line = end_line;
	}

}
