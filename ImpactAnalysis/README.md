# Impact Analysis README

Our impact analysis takes the suggestions produced by our completion framework and depcts how each suggestion would change the behavior of the model. 

## Requirements

- Java 21 or higher
- Alloy 6 jar with partial max-sat solver in build path

## How to Execute

- In the `scr` folder `ImpactAnalysis.java` contains the executable code to run the impact analysis focusing on minimal, similar scenarios.
- In the `scr` folder `ImpactAnalysis_NoTarget.java` contains the executable code to run the impact analysis using Alloy's default commonad execution.
- Both files take the following parameters:
  - Directory where the completion suggestions are stored 
  - Directory where to store the results of the experiments

# Experiments
- To replicate our experiments, all java files are currently set up to point to the directory with our completion suggestions in them (folder `test-results`)
- A base version of all the models we use in our experiments, consisting of the signatures and relations, is in the `models` folder.
- The data behind our results in the paper are stored in the `results` folder, including an excel file that will calculate all the information in our tables. This file can be updated with any new `.csv` files produced from running any of the `ImpactAnalysis.java` variants.
