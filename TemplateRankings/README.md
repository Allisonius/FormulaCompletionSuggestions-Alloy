# Template Rankings README

This folder contains the code to take a list of completion suggestions and re-rank them based on their match to common formula templates.

## Requirements

- Java 21 or higher
- Alloy 6 jar in build path

## How to Execute

- In the `scr` folder `RankList.java` contains the executable code to run rank a list based on templates.
- The file take the following parameters:
  - Cap on number of suggestions to be contrasted
  - Directory where the completion suggestion templated-based rankings are stored (`.TEMPLATERANK` file extensions)
  - Directory where to store the results of the experiments

# Experiments
- To replicate our experiments, the java files are currently set up to point to the directory with our completion suggestions (folder `test-results`)
- A base version of all the models we use in our experiments, consisting of the signatures and relations, is in the `models` folder.
- The data behind our results in the paper are stored in the `results` folder, including an excel file that will calculate all the information in our tables. This file can be updated with any new `.csv` produced from running `RankList.java` 
- An overview of the template information can be found in this main directory `TemplatesOverview.xlsx`
