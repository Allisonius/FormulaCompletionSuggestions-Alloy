# Contrasting Scenarios README

Contrasting scenarios take a template-ranked list as input, and contrast the first `X` suggestions. Contrasting scenarios can use the dafault Alloy execution or target a minimal scenario. 

## Requirements

- Java 21 or higher
- Alloy 6 jar with partial max-sat solver in build path

## How to Execute

- In the `scr` folder `ContrastingScenarios.java` contains the executable code to run the baseline contrasting scenario experiments.
- In the `scr` folder `ContrastingScenarios_WithTarget.java` contains the executable code to run the contrasting scenario experiments while aiming to produce as minimal of a scenario as possible.
- Both files take the following parameters:
  - Cap on number of suggestions to be contrasted
  - Directory where the completion suggestion templated-based rankings are stored (`.TEMPLATERANK` file extensions)
  - Directory where to store the results of the experiments

# Experiments
- To replicate our experiments, both java files are currently set up to point to the directory with our template rankings (folder `test-results`)
- A base version of all the models we use in our experiments, consisting of the signatures and relations, is in the `models` folder.
- The data behind our results in the paper are stored in the `results` folder, including an excel file that will calculate all the information in our tables. This file can be updated with any new `.csv` files produced from running `ContrastingScenarios.java` or `ContrastingScenarios_WithTarget.java`
