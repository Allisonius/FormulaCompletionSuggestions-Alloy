import { EvaluateSuggestions } from "./EvaluateSuggestions";
import { getDocUri } from "../../../utilities/helper";

const array = new EvaluateSuggestions(
  "array",
  getDocUri("completion/array-complete.als"),
);

const trainStationFol = new EvaluateSuggestions(
  "train-station-fol",
  getDocUri("completion/train-station-fol-complete.als"),
);

const trainStationLTL = new EvaluateSuggestions(
  "train-station-ltl",
  getDocUri("completion/train-station-ltl-complete.als"),
);

const trashFol = new EvaluateSuggestions(
  "trash-fol",
  getDocUri("completion/trash-fol-complete.als"),
);

const trashLtl = new EvaluateSuggestions(
  "trash-ltl",
  getDocUri("completion/trash-ltl-complete.als"),
);

const trashRL = new EvaluateSuggestions(
  "trash-rl",
  getDocUri("completion/trash-rl-complete.als"),
);

const smartHome = new EvaluateSuggestions(
  "smart-home",
  getDocUri("completion/smart_home-complete.als"),
);

const git = new EvaluateSuggestions(
  "git",
  getDocUri("completion/git-complete.als"),
);

const frankervrep = new EvaluateSuggestions(
  "frankervrep",
  getDocUri("completion/frankenvrep-complete.als"),
);

const diffAndCD2 = new EvaluateSuggestions(
  "diff-and-cd2",
  getDocUri("completion/diff-complete.als"),
);

const coursesV2 = new EvaluateSuggestions(
  "courses-v2",
  getDocUri("completion/courses-v2-complete.als"),
);

const classroomFol = new EvaluateSuggestions(
  "classroom-fol",
  getDocUri("completion/classroom-fol-complete.als"),
);

array.runEvaluation();
// trainStationFol.runEvaluation();
// trainStationLTL.runEvaluation();
// trashFol.runEvaluation();
// trashLtl.runEvaluation();
// trashRL.runEvaluation();
// smartHome.runEvaluation();
// git.runEvaluation();
// frankervrep.runEvaluation();
// diffAndCD2.runEvaluation();

coursesV2.runEvaluation();
classroomFol.runEvaluation();
