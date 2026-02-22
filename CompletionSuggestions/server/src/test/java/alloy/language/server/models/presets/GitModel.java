package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class GitModel {
	public static CompletionModelBuilder modelBuilder() {
		/**
		 * sig State {}
		 * <p>
		 * sig Name {
		 * heads : set State,
		 * HEAD : set State
		 * refs : Commit -> State
		 * }
		 * <p>
		 * abstract sig Node {
		 * name : one Name,
		 * parent : lone Dir,
		 * current : set State,		// set of nodes currently in file system
		 * samepath : set Node, 		// auxiliary relation
		 * // n -> o -> c in belongsTo iff  o is an object in c.tree that corresponds to n
		 * belongsTo : Object lone -> Commit
		 * }
		 * <p>
		 * sig File extends Node {
		 * content : one Blob,
		 * index : set State		// in staging area or not
		 * }
		 * <p>
		 * sig Dir extends Node {
		 * tbc : Tree -> State // auxiliary relation
		 * }
		 * one sig Root extends Dir {}
		 * <p>
		 * abstract sig Object {
		 * stored : set State
		 * }
		 * <p>
		 * sig Blob extends Object {
		 * conflict : set Blob,
		 * // b1 -> b2 -> b' in merging means b' is a result of merging b1 and b2
		 * merging : Blob -> lone Blob
		 * }
		 * <p>
		 * sig Tree extends Object {
		 * content : Name -> lone (Blob+Tree)
		 * }
		 * <p>
		 * sig Commit extends Object {
		 * previous : set Commit,
		 * tree : one Tree,
		 * }
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("sig State {}")
				.withContent("")
				.withContent("sig Name {")
				.withContent("heads : set State,")
				.withContent("HEAD : set State,")
				.withContent("refs : Commit -> State")
				.withContent("}")
				.withContent("")
				.withContent("abstract sig Node {")
				.withContent("name : one Name,")
				.withContent("parent : lone Dir,")
				.withContent("current : set State,")
				.withContent("samepath : set Node,")
				.withContent("belongsTo : Object lone -> Commit")
				.withContent("}")
				.withContent("")
				.withContent("sig File extends Node {")
				.withContent("content : one Blob,")
				.withContent("index : set State")
				.withContent("}")
				.withContent("")
				.withContent("sig Dir extends Node {")
				.withContent("tbc : Tree -> State")
				.withContent("}")
				.withContent("")
				.withContent("one sig Root extends Dir {}")
				.withContent("")
				.withContent("abstract sig Object {")
				.withContent("stored : set State")
				.withContent("}")
				.withContent("")
				.withContent("sig Blob extends Object {")
				.withContent("conflict : set Blob,")
				.withContent("merging : Blob -> lone Blob")
				.withContent("}")
				.withContent("")
				.withContent("sig Tree extends Object {")
				.withContent("content : Name -> lone (Blob+Tree)")
				.withContent("}")
				.withContent("")
				.withContent("sig Commit extends Object {")
				.withContent("previous : set Commit,")
				.withContent("tree : one Tree")
				.withContent("}")
				.withContent("fun children : Tree -> Object {\n" +
						"\t{t : Tree, o : Object | some n : Name | t->n->o in content}\n" +
						"}")
				.withContent("fun children[s : State, n : Node] : set Node {\n" +
						"\t(^parent).n & current.s\n" +
						"}")
		;
		return builder;
	}
}
