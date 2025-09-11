import { AlloyFileSetup } from "./AlloyFileSetup";
import { getDocUri } from "../../../utilities/helper";
import { get } from "http";

const classroom = new AlloyFileSetup(
  "classroom",
  getDocUri("completion/classroom-sig.als"),
  getDocUri("completion/classroom-complete.als")
);

const classroomFol = new AlloyFileSetup(
  "classroom-fol",
  getDocUri("completion/classroom-fol-sig.als"),
  getDocUri("completion/classroom-fol-complete.als")
);

const classroomRL = new AlloyFileSetup(
  "classroom-rl",
  getDocUri("completion/classroom-rl-sig.als"),
  getDocUri("completion/classroom-rl-complete.als")
);

const graph = new AlloyFileSetup(
  "graph",
  undefined,
  getDocUri("completion/graph-complete.als")
);

const trash = new AlloyFileSetup(
  "trash",
  undefined,
  getDocUri("completion/trash-complete.als")
);

const socialMedia = new AlloyFileSetup(
  "social-media",
  undefined,
  getDocUri("completion/socialMedia.als")
);

const courses = new AlloyFileSetup(
  "courses",
  getDocUri("completion/courses-sig.als"),
  getDocUri("completion/courses-complete.als")
);

const coursesV1 = new AlloyFileSetup(
  "courses-v1",
  getDocUri("completion/courses-v1-sig.als"),
  getDocUri("completion/courses-v1-complete.als")
);

const coursesV2 = new AlloyFileSetup(
  "courses-v2",
  getDocUri("completion/courses-v2-sig.als"),
  getDocUri("completion/courses-v2-complete.als")
);

const lts = new AlloyFileSetup(
  "lts",
  getDocUri("completion/lts-sig.als"),
  getDocUri("completion/lts-complete.als")
);

const productionLineV1 = new AlloyFileSetup(
  "production-line-v1",
  getDocUri("completion/production-line-v1-sig.als"),
  getDocUri("completion/production-line-v1-complete.als")
);

const productionLineV2 = new AlloyFileSetup(
  "production-line-v2",
  getDocUri("completion/production-line-v2-sig.als"),
  getDocUri("completion/production-line-v2-complete.als")
);

const productionLineV3 = new AlloyFileSetup(
  "production-line-v3",
  getDocUri("completion/production-line-v3-sig.als"),
  getDocUri("completion/production-line-v3-complete.als")
);

const trainStationFol = new AlloyFileSetup(
  "train-station-fol",
  getDocUri("completion/train-station-fol-sig.als"),
  getDocUri("completion/train-station-fol-complete.als")
);

const trainStationLTL = new AlloyFileSetup(
  "train-station-ltl",
  getDocUri("completion/train-station-ltl-sig.als"),
  getDocUri("completion/train-station-ltl-complete.als")
);

const cv = new AlloyFileSetup(
  "cv",
  getDocUri("completion/cv-sig.als"),
  getDocUri("completion/cv-complete.als")
);

const array = new AlloyFileSetup(
  "array",
  getDocUri("completion/array-sig.als"),
  getDocUri("completion/array-complete.als")
);

const binaryTree = new AlloyFileSetup(
  "binary-tree",
  undefined,
  getDocUri("completion/binary-tree-2.als")
);

const classDiagram = new AlloyFileSetup(
  "class-diagram",
  getDocUri("completion/class-diagram-sig.als"),
  getDocUri("completion/class-diagram-complete.als")
);

const cTree = new AlloyFileSetup(
  "c-tree",
  getDocUri("completion/ctree-sig.als"),
  getDocUri("completion/ctree-complete.als")
);

const dll = new AlloyFileSetup(
  "dll",
  undefined,
  getDocUri("completion/dll.als")
);

const singlyLinkedList = new AlloyFileSetup(
  "singly-linked-list",
  undefined,
  getDocUri("completion/singly-linked-list.als")
);

const fsm = new AlloyFileSetup(
  "fsm",
  undefined,
  getDocUri("completion/fsm.als")
);

const handshake = new AlloyFileSetup(
  "handshake",
  undefined,
  getDocUri("completion/handshake.als")
);

const trashFol = new AlloyFileSetup(
  "trash-fol",
  getDocUri("completion/trash-fol-sig.als"),
  getDocUri("completion/trash-fol-complete.als")
);

const trashRL = new AlloyFileSetup(
  "trash-rl",
  getDocUri("completion/trash-rl-sig.als"),
  getDocUri("completion/trash-rl-complete.als")
);

const trashLtl = new AlloyFileSetup(
  "trash-ltl",
  getDocUri("completion/trash-ltl-sig.als"),
  getDocUri("completion/trash-ltl-complete.als")
);

// const address = new AlloyFileSetup(
//   "address",
//   getDocUri("completion/address-sig.als"),
//   getDocUri("completion/address-complete.als")
// );

const bempl = new AlloyFileSetup(
  "bempl",
  getDocUri("completion/bempl-sig.als"),
  getDocUri("completion/bempl-complete.als")
);

const farmer = new AlloyFileSetup(
  "farmer",
  getDocUri("completion/farmer-sig.als"),
  getDocUri("completion/farmer-complete.als")
);

const grade = new AlloyFileSetup(
  "grade",
  getDocUri("completion/grade-sig.als"),
  getDocUri("completion/grade-complete.als")
);

const nQueens = new AlloyFileSetup(
  "nqueens",
  undefined,
  getDocUri("completion/nqueens.als")
);

const git = new AlloyFileSetup(
  "git",
  getDocUri("completion/git-sig.als"),
  getDocUri("completion/git-complete.als")
);

export {
  cTree,
  dll,
  singlyLinkedList,
  fsm,
  handshake,
  trashLtl,
  classDiagram,
  binaryTree,
  array,
  cv,
  productionLineV1,
  productionLineV2,
  productionLineV3,
  lts,
  courses,
  socialMedia,
  trash,
  trashFol,
  trashRL,
  trainStationFol,
  trainStationLTL,
  graph,
  classroomFol,
  // address,
  bempl,
  farmer,
  grade,
  nQueens,
  git,
  classroom,
  classroomRL,
  coursesV1,
  coursesV2,
};
