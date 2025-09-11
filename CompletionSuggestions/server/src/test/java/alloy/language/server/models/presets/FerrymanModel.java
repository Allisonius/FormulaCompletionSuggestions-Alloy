package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class FerrymanModel {
	public static CompletionModelBuilder modelBuilder() {
		/**
		 abstract sig Object {}

		 one sig Sheep, Wolf, Cabbage extends Object {}

		 var lone sig Boat in Object {}

		 var sig Left in Object {}

		 var sig Right in Object {}

		 fact initial {
		 Left = Sheep + Wolf + Cabbage
		 no Boat
		 no Right
		 }

		 fact transitions {
		 always no Left & Right
		 always no Left & Boat
		 always no Right & Boat
		 always ((some o: Object |
		 loadFromLeft[o]
		 or loadFromRight[o]
		 or unloadOnLeft[o]
		 or unloadOnRight[o]) or
		 (some disj o1, o2: Object | exchangeAtLeft[o1, o2] or exchangeAtRight[o1, o2])
		 )
		 }

		 pred exchangeAtLeft[o1, o2: Object] {
		 o1 in Left
		 Right' = Right
		 Left' = o2 + Left - o1
		 Boat' = o1 + Boat - o2
		 }

		 pred exchangeAtRight[o1, o2: Object] {
		 o1 in Right
		 Left' = Left
		 Right' = o2 + Right - o1
		 Boat' = o1 + Boat - o2
		 }

		 pred loadFromLeft[o: Object] {
		 o in Left
		 Right' = Right
		 Left' = Left - o
		 Boat' = Boat + o
		 }

		 pred loadFromRight[o: Object] {
		 o in Right
		 Left' = Left
		 Right' = Right - o
		 Boat' = Boat + o
		 }

		 pred unloadOnLeft[o: Object] {
		 o in Boat
		 Right' = Right
		 Left' = Left + o
		 Boat' = Boat - o
		 }

		 pred unloadOnRight[o: Object] {
		 o in Boat
		 Left' = Left
		 Right' = Right + o
		 Boat' = Boat - o
		 }

		 pred NoSheepWolf {
		 Sheep + Wolf != Boat
		 Sheep + Wolf != Left
		 Sheep + Wolf != Right
		 }

		 pred NoCabbageSheep {
		 Sheep + Cabbage != Boat
		 Sheep + Cabbage != Left
		 Sheep + Cabbage != Right
		 }

		 pred validate {
		 NoSheepWolf
		 NoCabbageSheep
		 }

		 pred moved {
		 always validate
		 eventually Right = Sheep + Wolf + Cabbage
		 }

		 run moved

		 assert sheepAlive {
		 always Sheep in Left => Wolf not in Left
		 }

		 check sheepAlive
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("abstract sig Object {}")
		       .withContent("one sig Sheep, Wolf, Cabbage extends Object {}")
		       .withContent("var lone sig Boat in Object {}")
		       .withContent("var sig Left in Object {}")
		       .withContent("var sig Right in Object {}")
		       .withContent("fact initial {")
		       .withCompletionLine("Left = Sheep + Wolf + Cabbage")
		       .withCompletionLine("no Boat")
		       .withCompletionLine("no Right")
		       .withContent("}")
		       .withContent("fact transitions {")
		       .withCompletionLine("always no Left & Right")
		       .withCompletionLine("always no Left & Boat")
		       .withCompletionLine("always no Right & Boat")
		       .withCompletionLine("always ((some o: Object | loadFromLeft[o] or loadFromRight[o] or unloadOnLeft[o] or unloadOnRight[o]) or (some disj o1, o2: Object | exchangeAtLeft[o1, o2] or exchangeAtRight[o1, o2]))")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred exchangeAtLeft[o1, o2: Object] {")
		       .withCompletionLine("o1 in Left")
		       .withCompletionLine("Right' = Right")
		       .withCompletionLine("Left' = o2 + Left - o1")
		       .withCompletionLine("Boat' = o1 + Boat - o2")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred exchangeAtRight[o1, o2: Object] {")
		       .withCompletionLine("o1 in Right")
		       .withCompletionLine("Left' = Left")
		       .withCompletionLine("Right' = o2 + Right - o1")
		       .withCompletionLine("Boat' = o1 + Boat - o2")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred loadFromLeft[o: Object] {")
		       .withCompletionLine("o in Left")
		       .withCompletionLine("Right' = Right")
		       .withCompletionLine("Left' = Left - o")
		       .withCompletionLine("Boat' = Boat + o")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred loadFromRight[o: Object] {")
		       .withCompletionLine("o in Right")
		       .withCompletionLine("Left' = Left")
		       .withCompletionLine("Right' = Right - o")
		       .withCompletionLine("Boat' = Boat + o")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred unloadOnLeft[o: Object] {")
		       .withCompletionLine("o in Boat")
		       .withCompletionLine("Right' = Right")
		       .withCompletionLine("Left' = Left + o")
		       .withCompletionLine("Boat' = Boat - o")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred unloadOnRight[o: Object] {")
		       .withCompletionLine("o in Boat")
		       .withCompletionLine("Left' = Left")
		       .withCompletionLine("Right' = Right + o")
		       .withCompletionLine("Boat' = Boat - o")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred NoSheepWolf {")
		       .withCompletionLine("Sheep + Wolf != Boat")
		       .withCompletionLine("Sheep + Wolf != Left")
		       .withCompletionLine("Sheep + Wolf != Right")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred NoCabbageSheep {")
		       .withCompletionLine("Sheep + Cabbage != Boat")
		       .withCompletionLine("Sheep + Cabbage != Left")
		       .withCompletionLine("Sheep + Cabbage != Right")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred validate {")
		       .withCompletionLine("NoSheepWolf")
		       .withCompletionLine("NoCabbageSheep")
		       .withContent("}")
		       .withContent("")
		       .withContent("pred moved {")
		       .withCompletionLine("always validate")
		       .withCompletionLine("eventually Right = Sheep + Wolf + Cabbage")
		       .withContent("}")
		       .withContent("")
		       .withContent("run moved")
		       .withContent("")
		       .withContent("assert sheepAlive {")
		       .withCompletionLine("always Sheep in Left => Wolf not in Left")
		       .withContent("}")
		       .withContent("")
		       .withContent("check sheepAlive");
		return builder;
	}

}
