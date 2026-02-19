abstract sig ArmAngle, Coordinate {}

abstract sig Side{}
lone sig Left extends Side{}
lone sig Right extends Side{}

abstract sig HapticFeedback{}
one sig HapticsEnabled extends HapticFeedback{}
one sig HapticsDisabled extends HapticFeedback{}

abstract sig EffectorType{}
lone sig Cautery_Tissue_Grasper extends EffectorType{}
lone sig Cautery_Shears extends EffectorType{}
lone sig Cautery_Hook extends EffectorType{}
lone sig Tissue_Grasper extends EffectorType{}
lone sig Shears extends EffectorType{}

abstract sig PedalFunction{}
one sig ClutchButton extends PedalFunction{}
one sig HPButton extends PedalFunction{}
one sig ScaleButton extends PedalFunction{}
one sig CauteryButton extends PedalFunction{}

sig PedalButton{
	assigned: one PedalFunction
}

abstract sig Plugin {}

abstract sig GeomagicTouch {
	input: one Coordinate,
	force: some HapticFeedback
}

abstract one sig RobotApp {
	includes: some Plugin
}

abstract one sig LoadedPlugins {
	loads: some Plugin
}

abstract sig SolverFamily{
	calls: one KinematicModel
}

// specifies the solver
abstract sig KinematicModel{
	solverResult: Coordinate -> ArmAngle
}

abstract one sig Robot {
	arms: some RobotArm
}

abstract sig RobotArm{
	armside: one Side,
	armModel: one ArmType,
	effectorType: one EffectorType
}

abstract sig ArmType {
	anglelimit: set ArmAngle, //set of all the arm angles that are less than limit
	inverseKSolver: one KinematicModel
}

abstract sig RobotControl{
	output: set ArmAngle
}

one sig Clutch_Plugin extends Plugin{}
one sig GeomagicTouch_plugin extends Plugin{}
one sig HomePosition extends Plugin{}
one sig GrasperLimits extends Plugin{}
one sig Scale extends Plugin{}
one sig DummyController extends Plugin{}
one sig ButtonInterface extends	Plugin{
	setButtonForPedal : some PedalButton
}
abstract sig SolverPlugin extends Plugin{
	solverfamily: one SolverFamily
}

sig armangle extends ArmAngle{}
sig xyz_input extends Coordinate{}

// plugins expected from a typical config file
one sig GeomagicTouchPlugin_instance extends 
one sig HomePosition_instance extends HomePosition{}
one sig Clutch_instance extends Clutch_Plugin{}
one sig IKSolver_plugin extends SolverPlugin{}
one sig ButtonInterface_instance extends ButtonInterface{}

one sig loaded_plugins_of_ extends LoadedPlugins {}{
	GeomagicTouchPlugin_instance +
	HomePosition_instance +
	Clutch_instance +
	IKSolver_plugin +
	ButtonInterface_instance
	in loads
}

one sig IKSolver_family extends SolverFamily{}{
	calls = FrankenBot
}

one sig FrankenBot extends KinematicModel{}

one sig FrankenVREP extends ArmType{}{
	inverseKSolver = FrankenBot
}

one sig FrankenVREPArm extends RobotArm{}{
	armModel = FrankenVREP
}

one sig UsedGeomagicTouch extends GeomagicTouch {}{
	force = HapticsDisabled
}

fact {
    HapticsDisabled in	UsedGeomagicTouch.force
}

one sig Current_Robot extends Robot {}{
	arms = FrankenVREPArm
}
// return the angles produced from a specific coordinate
fun getArmAngles[s: KinematicModel, c: Coordinate] : one (ArmAngle) {
	s.solverResult[c]
}
