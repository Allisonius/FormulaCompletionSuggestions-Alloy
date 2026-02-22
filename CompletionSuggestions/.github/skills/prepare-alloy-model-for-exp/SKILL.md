---
name: prepare-alloy-model-for-exp
description: Prepare an Alloy model for experimental evaluation by modifying an original alloy model file and adding the files in the test suite.
---

# Skill: Prepare Alloy Model for Experimental Evaluation
This skill prepares an Alloy model for experimental evaluation by modifying the original Alloy model file and incorporating the files from the test suite.

## Inputs
- `original_alloy_model`: The original Alloy model file that needs to be modified.

## Steps

### 1. Sanitize the Original Alloy Model
- Read the content of the `original_alloy_model` file.
- if there are not `var` declarations in the model, then replace all occurrences of `'` with the last character of the word that contains the `'` character. For example, convert `s'` to `ss`, or `n'` to `nn`.
- If there are `enum` declarations in the model, then replace all occurrences of `enum` name with `abstract sig` and to convert enumerations into signatures extending the `Enum` signature. For example, convert:
  ```alloy
  enum Color { Red, Green, Blue }
  ```
  to:
  ```alloy
  abstract sig Color {}
  sig Red, Green, Blue extends Color {}
  ```
- If the model contains facts within signature declarations, like `sig A { facts... }`, then move those facts outside the signature declaration and convert them into standalone `fact` blocks. For example, convert:
  ```alloy
  sig A { facts... }
  ```
  to:
  ```alloy
  sig A {}
  fact A_facts { facts... }
  ```

### 2. Move all the `signature` Declarations to the Top
- Identify all `signature` declarations in the Alloy model.
- Move these declarations to the top of the Alloy model file, ensuring that they are placed before all formulas.

### 3. Make a `<model_name>-sig` file and a `<model_name>-complete` file
- Copy the modified Alloy model content into a new file named `<model_name>-sig.als`, where `<model_name>` is derived from the original model's filename.
- Remove all the code after the last `signature` declaration in the `<model_name>-sig.als` file.
- Rename the original Alloy model file to `<model_name>-complete.als`.

### 4. Ensure the models are in the correct directory
- Place the newly created `<model_name>-sig.als` and `<model_name>-complete.als` files in the [client/test/fixtures/completion/](client/test/fixtures/completion/) directory to ensure they are accessible for testing.

### 5. Register the text fixture model files in the Model Runners
- Add the newly created `<model_name>-sig.als` and `<model_name>-complete.als` files in the [model-runners.js](client/test/suites/model-runners.js) file to ensure they are included in the test suite for experimental evaluation.
- Add the code in the following format to the `model-runners.js` file:
```javascript
const <model_name> = new AlloyFileSetup(
  "<model_name>",
  getDocUri("completion/<model_name>-sig.als"),
  getDocUri("completion/<model_name>-complete.als")
);
...
export {
  ...
  <model_name>,
  ...
};
```

### 6. Include the Model in the Test Suites
- Import the newly created model in the relevant test suite files located in [multi-term.test.ts](client/test/suites/multi-term.test.ts).
- Add the test invocations for the new model in the test suite to ensure it is evaluated during testing.
```javascript
import { <model_name> } from "./model-runners";
...
<model_name>.runMultiTermTests();
```

## Check final setup
- Verify that the `<model_name>-sig.als` and `<model_name>-complete.als` files are correctly created and contain the expected content.
- Ensure that the model is properly registered in the `model-runners.js` file and included in the test suites for experimental evaluation.
- Ensure that the model is included in the `multi-term.test.ts` file for testing.
