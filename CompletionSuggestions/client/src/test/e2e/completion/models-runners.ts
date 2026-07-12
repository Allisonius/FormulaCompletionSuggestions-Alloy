import { AlloyFileSetup } from "./AlloyFileSetup";
import { getDocUri } from "../../../utilities/helper";

const classroom = new AlloyFileSetup(
  "classroom",
  getDocUri("completion/classroom-sig.als"),
  getDocUri("completion/classroom-complete.als"),
);

const classroomFol = new AlloyFileSetup(
  "classroom-fol",
  getDocUri("completion/classroom-fol-sig.als"),
  getDocUri("completion/classroom-fol-complete.als"),
);

const classroomRL = new AlloyFileSetup(
  "classroom-rl",
  getDocUri("completion/classroom-rl-sig.als"),
  getDocUri("completion/classroom-rl-complete.als"),
);

const graph = new AlloyFileSetup(
  "graph",
  undefined,
  getDocUri("completion/graph-complete.als"),
);

const trash = new AlloyFileSetup(
  "trash",
  undefined,
  getDocUri("completion/trash-complete.als"),
);

const socialMedia = new AlloyFileSetup(
  "social-media",
  undefined,
  getDocUri("completion/socialMedia.als"),
);

const courses = new AlloyFileSetup(
  "courses",
  getDocUri("completion/courses-sig.als"),
  getDocUri("completion/courses-complete.als"),
);

const coursesV1 = new AlloyFileSetup(
  "courses-v1",
  getDocUri("completion/courses-v1-sig.als"),
  getDocUri("completion/courses-v1-complete.als"),
);

const coursesV2 = new AlloyFileSetup(
  "courses-v2",
  getDocUri("completion/courses-v2-sig.als"),
  getDocUri("completion/courses-v2-complete.als"),
);

const lts = new AlloyFileSetup(
  "lts",
  getDocUri("completion/lts-sig.als"),
  getDocUri("completion/lts-complete.als"),
);

const productionLineV1 = new AlloyFileSetup(
  "production-line-v1",
  getDocUri("completion/production-line-v1-sig.als"),
  getDocUri("completion/production-line-v1-complete.als"),
);

const productionLineV2 = new AlloyFileSetup(
  "production-line-v2",
  getDocUri("completion/production-line-v2-sig.als"),
  getDocUri("completion/production-line-v2-complete.als"),
);

const productionLineV3 = new AlloyFileSetup(
  "production-line-v3",
  getDocUri("completion/production-line-v3-sig.als"),
  getDocUri("completion/production-line-v3-complete.als"),
);

const trainStationFol = new AlloyFileSetup(
  "train-station-fol",
  getDocUri("completion/train-station-fol-sig.als"),
  getDocUri("completion/train-station-fol-complete.als"),
);

const trainStationLTL = new AlloyFileSetup(
  "train-station-ltl",
  getDocUri("completion/train-station-ltl-sig.als"),
  getDocUri("completion/train-station-ltl-complete.als"),
);

const cv = new AlloyFileSetup(
  "cv",
  getDocUri("completion/cv-sig.als"),
  getDocUri("completion/cv-complete.als"),
);

const array = new AlloyFileSetup(
  "array",
  getDocUri("completion/array-sig.als"),
  getDocUri("completion/array-complete.als"),
);

const binaryTree = new AlloyFileSetup(
  "binary-tree",
  undefined,
  getDocUri("completion/binary-tree-2.als"),
);

const classDiagram = new AlloyFileSetup(
  "class-diagram",
  getDocUri("completion/class-diagram-sig.als"),
  getDocUri("completion/class-diagram-complete.als"),
);

const cTree = new AlloyFileSetup(
  "c-tree",
  getDocUri("completion/ctree-sig.als"),
  getDocUri("completion/ctree-complete.als"),
);

const dll = new AlloyFileSetup(
  "dll",
  undefined,
  getDocUri("completion/dll.als"),
);

const singlyLinkedList = new AlloyFileSetup(
  "singly-linked-list",
  undefined,
  getDocUri("completion/singly-linked-list.als"),
);

const fsm = new AlloyFileSetup(
  "fsm",
  undefined,
  getDocUri("completion/fsm.als"),
);

const handshake = new AlloyFileSetup(
  "handshake",
  undefined,
  getDocUri("completion/handshake.als"),
);

const icd = new AlloyFileSetup(
  "icd",
  getDocUri("completion/icd-sig.als"),
  getDocUri("completion/icd-complete.als"),
);

const trashFol = new AlloyFileSetup(
  "trash-fol",
  getDocUri("completion/trash-fol-sig.als"),
  getDocUri("completion/trash-fol-complete.als"),
);

const trashRL = new AlloyFileSetup(
  "trash-rl",
  getDocUri("completion/trash-rl-sig.als"),
  getDocUri("completion/trash-rl-complete.als"),
);

const trashLtl = new AlloyFileSetup(
  "trash-ltl",
  getDocUri("completion/trash-ltl-sig.als"),
  getDocUri("completion/trash-ltl-complete.als"),
);

// const address = new AlloyFileSetup(
//   "address",
//   getDocUri("completion/address-sig.als"),
//   getDocUri("completion/address-complete.als")
// );

const bempl = new AlloyFileSetup(
  "bempl",
  getDocUri("completion/bempl-sig.als"),
  getDocUri("completion/bempl-complete.als"),
);

const farmer = new AlloyFileSetup(
  "farmer",
  getDocUri("completion/farmer-sig.als"),
  getDocUri("completion/farmer-complete.als"),
);

const grade = new AlloyFileSetup(
  "grade",
  getDocUri("completion/grade-sig.als"),
  getDocUri("completion/grade-complete.als"),
);

const nQueens = new AlloyFileSetup(
  "nqueens",
  undefined,
  getDocUri("completion/nqueens.als"),
);

const git = new AlloyFileSetup(
  "git",
  getDocUri("completion/git-sig.als"),
  getDocUri("completion/git-complete.als"),
);

const frankervrep = new AlloyFileSetup(
  "frankervrep",
  getDocUri("completion/frankenvrep-sig.als"),
  getDocUri("completion/frankenvrep-complete.als"),
);

const checkmate = new AlloyFileSetup(
  "checkmate",
  getDocUri("completion/checkmate-sig.als"),
  getDocUri("completion/checkmate-complete.als"),
);

const chord = new AlloyFileSetup(
  "chord",
  getDocUri("completion/chordfull-sig.als"),
  getDocUri("completion/chordfull-complete.als"),
);

const diffAndCD2 = new AlloyFileSetup(
  "diff-and-cd2",
  getDocUri("completion/diff-sig.als"),
  getDocUri("completion/diff-complete.als"),
);

const smartHome = new AlloyFileSetup(
  "smart-home",
  getDocUri("completion/smart_home-sig.als"),
  getDocUri("completion/smart_home-complete.als"),
);

const sdwSimplified = new AlloyFileSetup(
  "sdw-simplified",
  getDocUri("completion/sdw-simplified-sig.als"),
  getDocUri("completion/sdw-simplified-complete.als"),
);

const projetoLogica = new AlloyFileSetup(
  "projeto-logica",
  getDocUri("completion/ProjetoLogica-sig.als"),
  getDocUri("completion/ProjetoLogica-complete.als"),
);

const gatewayTCB = new AlloyFileSetup(
  "Gateway_TCB",
  getDocUri("completion/Gateway_TCB-sig.als"),
  getDocUri("completion/Gateway_TCB-complete.als"),
);

const statecoverage = new AlloyFileSetup(
  "statecoverage",
  getDocUri("completion/statecoverage-sig.als"),
  getDocUri("completion/statecoverage-complete.als"),
);

const drone = new AlloyFileSetup(
  "drone",
  getDocUri("completion/Drone-sig.als"),
  getDocUri("completion/Drone-complete.als"),
);

const theatre = new AlloyFileSetup(
  "theatre",
  getDocUri("completion/theatre-sig.als"),
  getDocUri("completion/theatre-complete.als"),
);

const javaMetaModel = new AlloyFileSetup(
  "java_meta_model",
  getDocUri("completion/java_meta_model-sig.als"),
  getDocUri("completion/java_meta_model-complete.als"),
);

const randomSkiJumping = new AlloyFileSetup(
  "random_ski_jumping",
  getDocUri("completion/random_ski_jumping-sig.als"),
  getDocUri("completion/random_ski_jumping-complete.als"),
);

const onlineShop = new AlloyFileSetup(
  "online-shop",
  getDocUri("completion/OnlineShop-fixed-sig.als"),
  getDocUri("completion/OnlineShop-fixed-complete.als"),
);

const modeloAlloy = new AlloyFileSetup(
  "modelo-alloy",
  getDocUri("completion/ModeloAlloy-sig.als"),
  getDocUri("completion/ModeloAlloy-complete.als"),
);

const gitRedacted = new AlloyFileSetup(
  "git-redacted",
  getDocUri("completion/git-sig.als"),
  getDocUri("completion/git-complete-redacted.als"),
);

const modeloAlloyFixables = new AlloyFileSetup(
  "modelo-alloy-fixable",
  getDocUri("completion/ModeloAlloy-sig.als"),
  getDocUri("completion/ModeloAlloy-complete-fixable.als"),
);

const javaMetaModelFixable = new AlloyFileSetup(
  "java-meta-model-fixable",
  getDocUri("completion/java_meta_model-sig.als"),
  getDocUri("completion/java_meta_model-complete-fixable.als"),
);

const randomSkiJumpingFixable = new AlloyFileSetup(
  "random-ski-jumping-fixable",
  getDocUri("completion/random_ski_jumping-sig.als"),
  getDocUri("completion/random_ski_jumping-complete-fixable.als"),
);

const gitFixable = new AlloyFileSetup(
  "git-fixable",
  getDocUri("completion/git-sig.als"),
  getDocUri("completion/git-complete-fixable.als"),
);

const coursesv1Fixable = new AlloyFileSetup(
  "courses-v1-fixable",
  getDocUri("completion/courses-v1-sig.als"),
  getDocUri("completion/courses-v1-complete-fixable.als"),
);

const coursesV2Fixable = new AlloyFileSetup(
  "courses-v2-fixable",
  getDocUri("completion/courses-v2-sig.als"),
  getDocUri("completion/courses-v2-complete-fixable.als"),
);

const tcp = new AlloyFileSetup(
  "tcp",
  getDocUri("completion/tcp-sig.als"),
  getDocUri("completion/tcp-complete.als"),
);

const kafkaFinal = new AlloyFileSetup(
  "kafka_final",
  getDocUri("completion/kafka_final-sig.als"),
  getDocUri("completion/kafka_final-complete.als"),
);

const digitalWatch = new AlloyFileSetup(
  "digital-watch",
  getDocUri("completion/digital-watch-sig.als"),
  getDocUri("completion/digital-watch-complete.als"),
);

const libPropMerged = new AlloyFileSetup(
  "lib_prop_merged",
  getDocUri("completion/lib_prop_merged-sig.als"),
  getDocUri("completion/lib_prop_merged-complete.als"),
);

const needhamSchroederPublicKey = new AlloyFileSetup(
  "needhamSchroederPublicKey",
  getDocUri("completion/needhamSchroederPublicKey-sig.als"),
  getDocUri("completion/needhamSchroederPublicKey-complete.als"),
);

const elevator = new AlloyFileSetup(
  "elevator",
  getDocUri("completion/elevator-sig.als"),
  getDocUri("completion/elevator-complete.als"),
);

const aman = new AlloyFileSetup(
  "aman",
  getDocUri("completion/aman-sig.als"),
  getDocUri("completion/aman-complete.als"),
);

const ertms = new AlloyFileSetup(
  "ertms",
  getDocUri("completion/ertms-sig.als"),
  getDocUri("completion/ertms-complete.als"),
);

const c11Purturbed = new AlloyFileSetup(
  "c11_purturbed",
  getDocUri("completion/c11_purturbed-sig.als"),
  getDocUri("completion/c11_purturbed-complete.als"),
);

const powerPurturbed = new AlloyFileSetup(
  "power_purturbed",
  getDocUri("completion/power_purturbed-sig.als"),
  getDocUri("completion/power_purturbed-complete.als"),
);

const hamsters = new AlloyFileSetup(
  "hamsters",
  getDocUri("completion/hamsters-sig.als"),
  getDocUri("completion/hamsters-complete.als"),
);

const androidPermission = new AlloyFileSetup(
  "android-permission",
  getDocUri("completion/android-permission-sig.als"),
  getDocUri("completion/android-permission-complete.als"),
);

const mcaMerged = new AlloyFileSetup(
  "mca-merged",
  getDocUri("completion/mca-merged-sig.als"),
  getDocUri("completion/mca-merged-complete.als"),
);

const dltSystemMerged = new AlloyFileSetup(
  "DLTSystem-merged",
  getDocUri("completion/DLTSystem-merged-sig.als"),
  getDocUri("completion/DLTSystem-merged-complete.als"),
);

const governanceMerged = new AlloyFileSetup(
  "Governance-merged",
  getDocUri("completion/Governance-merged-sig.als"),
  getDocUri("completion/Governance-merged-complete.als"),
);

const ledgerMerged = new AlloyFileSetup(
  "Ledger-merged",
  getDocUri("completion/Ledger-merged-sig.als"),
  getDocUri("completion/Ledger-merged-complete.als"),
);

export {
  cTree,
  dll,
  singlyLinkedList,
  fsm,
  handshake,
  icd,
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
  frankervrep,
  checkmate,
  chord,
  diffAndCD2,
  smartHome,
  sdwSimplified,
  projetoLogica,
  gatewayTCB,
  statecoverage,
  drone,
  theatre,
  javaMetaModel,
  randomSkiJumping,
  onlineShop,
  modeloAlloy,
  gitRedacted,
  modeloAlloyFixables,
  javaMetaModelFixable,
  randomSkiJumpingFixable,
  gitFixable,
  coursesv1Fixable,
  coursesV2Fixable,
  tcp,
  kafkaFinal,
  digitalWatch,
  libPropMerged,
  needhamSchroederPublicKey,
  elevator,
  aman,
  ertms,
  c11Purturbed,
  powerPurturbed,
  hamsters,
  androidPermission,
  mcaMerged,
  dltSystemMerged,
  governanceMerged,
  ledgerMerged,
};
