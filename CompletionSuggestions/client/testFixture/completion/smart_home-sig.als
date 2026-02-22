module smart_home

// On/Off state
abstract sig State {}
lone sig On extends State {}
lone sig Off extends State {}

// Occupied state
abstract sig VolumeState {}
one sig Empty extends VolumeState {}
one sig Partiall extends VolumeState {}
one sig Full extends VolumeState {}

abstract sig DirtyinessState {}
one sig Clean extends DirtyinessState {}
one sig Dirty extends DirtyinessState {}

one sig Home {
	id : one Int,
	rooms : set Room
}

sig Room {
	id : one Int,
	devices : set Device,
	state : one DirtyinessState
}

abstract sig Device {
	id : one Int,
	state : one State,
	sensors : set Sensor
}

abstract sig IndoorDevice extends Device {
	room : one Room
}
abstract sig OutdoorDevice extends Device {
	home : one Home
}

sig InLamp extends IndoorDevice {
}

sig Outlet extends IndoorDevice {
	size : one Int,
	occupation : one VolumeState
}

sig PetFeeder extends IndoorDevice {
	filling : one VolumeState
}

sig Radiator extends IndoorDevice {
}

sig Vacuum extends IndoorDevice {
	roomsToClean : set Room
}

sig Lock extends IndoorDevice {
}

sig AC extends IndoorDevice {
}

sig OutLamp extends OutdoorDevice {
}

sig LawnMover extends OutdoorDevice {
}

sig Shutter extends OutdoorDevice {
}


abstract sig Sensor {
	id : one Int,
	value : one Int,
	state : one State
}

sig Thermometer extends Sensor {}
sig Barometer extends Sensor {}
sig Photodetector extends Sensor {}
sig MotionDetector extends Sensor {}
sig WindDetector extends Sensor {}
sig Clock extends Sensor {}
//simple pressure detector - something is sitting there or it is not
sig PressureDetector extends Sensor {}
//abstraction of manual wireless controller
sig ManualDetector extends Sensor {}
