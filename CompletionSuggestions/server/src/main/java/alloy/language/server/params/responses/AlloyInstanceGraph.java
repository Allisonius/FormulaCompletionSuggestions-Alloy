package alloy.language.server.params.responses;

import org.eclipse.lsp4j.jsonrpc.validation.NonNull;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class AlloyInstanceGraph {
	public static class Atom {
		String id;
		public String name;
		public String sig;
		public List<String> subTypes;

		public Atom(String name, String sig) {
			this(name, name, sig);
		}

		public Atom(String id, String name, String sig) {
			this.id = id;
			this.name = name;
			this.sig = sig;
			this.subTypes = new ArrayList<>();
		}

		@Override
		public String toString() {
			return "Atom{" + "id='" + id + '\'' + ", name='" + name + '\'' + ", sig='" + sig + '\'' + ", subTypes=" + subTypes + '}';
		}

		public void addSubType(String subType) {
			this.subTypes.add(subType);
		}
	}

	public static class Relation {
		String id;
		public String label;
		public String source;
		public String target;
		public List<String> intermediates;

		public Relation(String label, String source, String target) {
			this(source + "-" + label + "->" + target, label, source, target);
		}

		public Relation(String id, String label, String source, String target) {
			this.id = id;
			this.label = label;
			this.source = source;
			this.target = target;
			this.intermediates = new ArrayList<>();
		}

		@Override
		public String toString() {
			return "Relation{" + "id='" + id + '\'' + ", label='" + label + '\'' + ", source='" + source + '\'' + ", target='" + target + '\'' + ", intermediates=" + intermediates + '}';
		}

		public void addIntermediate(String intermediate) {
			this.intermediates.add(intermediate);
		}
	}

	public Set<String> sigs = new HashSet<>();
	public Set<Atom> atoms = new HashSet<>();
	public Set<Relation> relations = new HashSet<>();

	public String textContent;
	public String tableContent;
	public boolean isTemporal = false;
	public int loop = 0;
	public int end = 0;

	public AlloyInstanceGraph() {
	}

	public AlloyInstanceGraph(String textContent, String tableContent) {
		this.textContent = textContent;
		this.tableContent = tableContent;
	}

	public AlloyInstanceGraph(Set<String> sigs, Set<Atom> atoms, Set<Relation> relations) {
		this.sigs = sigs;
		this.atoms = atoms;
		this.relations = relations;
	}

	public AlloyInstanceGraph(String textContent, String tableContent, Set<String> sigs, Set<Atom> atoms, Set<Relation> relations) {
		this.textContent = textContent;
		this.tableContent = tableContent;
		this.sigs = sigs;
		this.atoms = atoms;
		this.relations = relations;
	}

	public AlloyInstanceGraph(String textContent, String tableContent, Set<String> sigs, Set<Atom> atoms, Set<Relation> relations, boolean isTemporal, int loop, int end) {
		this.textContent = textContent;
		this.tableContent = tableContent;
		this.sigs = sigs;
		this.atoms = atoms;
		this.relations = relations;
		this.isTemporal = isTemporal;
		this.loop = loop;
		this.end = end;
	}

	public Set<String> getSigs() {
		return sigs;
	}

	public void setSigs(@NonNull Set<String> sigs) {
		this.sigs = sigs;
	}

	public Set<Atom> getAtoms() {
		return atoms;
	}

	public void setAtoms(@NonNull Set<Atom> atoms) {
		this.atoms = atoms;
	}

	public Set<Relation> getRelations() {
		return relations;
	}

	public void setRelations(@NonNull Set<Relation> relations) {
		this.relations = relations;
	}

	public String getTextContent() {
		return textContent;
	}

	public void setTextContent(String textContent) {
		this.textContent = textContent;
	}

	public String getTableContent() {
		return tableContent;
	}

	public void setTableContent(String tableContent) {
		this.tableContent = tableContent;
	}

	public boolean isTemporal() {
		return isTemporal;
	}
	public void setTemporal(boolean temporal) {
		isTemporal = temporal;
	}
	public int getLoop() {
		return loop;
	}
	public void setLoop(int loop) {
		this.loop = loop;
	}
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}

	@Override
	public String toString() {
		return "AlloyInstanceGraph{" +
				"sigs=" + sigs +
				", atoms=" + atoms +
				", relations=" + relations +
				", textContent='" + textContent + '\'' +
				", tableContent='" + tableContent + '\'' +
				", isTemporal=" + isTemporal +
				", loop=" + loop +
				", end=" + end +
				'}';
	}
}
