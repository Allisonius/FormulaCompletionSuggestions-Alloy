# Corpus Templates README

The basis of our template-based rankings is templates formed over models pulled from Github.

## Requirements

- Java 21 or higher
- Alloy 5 or later jar file in the build path

# Corpus
- The folder  `model-set` contains the models pulled and filtered from Github.
  
## How to Execute

- In the `scr` folder `GatherTemplates_NoRecursive.java` will iterative over all models and log the templates without recursively navigating over relational join expressions beyond their first encounter. This is the version used in our paper, to avoid overcounting completions.
- In the `scr` folder `GatherTemplates.java` will iterative over all models and log the templates while recursively navigating over relational join expressions to the SigExpr, FieldExpr or VarExpr lowest levels.
- Both files take the following parameters:
  - High or detailed templates. In our paper, we use detailed templates. These would take an expression like "sig.rel" and store the template as [sig].[rel]. High level templates would store the template as [name].[name]
  - Directory of the corpus
  - Directory where to store the results 

# Experiments
- To replicate our templates, extract the zip file in the ``model-sets` folder which zipped up the current corpus
- Run `GatherTemplates_NoRecursive.java`
- The folder `Results_Delated_NoRecursive` stores the templates that informed out hueristics in the paper.

# Template Visitors
- Within the  `scr - parser - ast - visitor` folder structure, the vistor pattern that produces and stores templates for all Alloy operators can be found.
