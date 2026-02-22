package alloy.language.server.params;

public interface ModelStats {
	record ModelStatsRequest (
			String documentUri
	) {}

	record ModelStatsResponse (
			Integer numSignatures,
			Integer numRelations,
			Integer numFunctions,
			Integer numFacts,
			Integer numPredicates,
			Integer numAssertions,
			Integer numCommands,
			Integer numOfFormulas
	){}
}
