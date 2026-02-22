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

fact {all dev : InLamp | some clock : Clock | clock in dev.sensors }
fact {all dev : InLamp | some manual : ManualDetector | manual in dev.sensors}
fact {all dev : Outlet | some pressure : PressureDetector | pressure in dev.sensors }
fact {all dev : PetFeeder | some pressure : PressureDetector | pressure in dev.sensors }
fact {all dev : Lock | some manual : ManualDetector | manual in dev.sensors }
fact {all dev : AC | some therm : Thermometer | therm in dev.sensors }
fact {all dev : OutLamp | some photoDet : Photodetector | photoDet in dev.sensors }
fact {all dev : OutLamp | some motionDet : MotionDetector | motionDet in dev.sensors }
fact {all dev : LawnMover | some barom : Barometer | barom in dev.sensors }
fact {all dev : LawnMover | some clock : Clock | clock in dev.sensors }
fact {all dev : Shutter | some photoDet : Photodetector | photoDet in dev.sensors }
fact {all dev : Shutter | some clock : Clock | clock in dev.sensors }
fact {all dev : Shutter | some windDet : WindDetector | windDet in dev.sensors }
fact {all dev : Radiator | some therm : Thermometer | therm in dev.sensors }
fact {all dev : Vacuum | some clock : Clock | clock in dev.sensors }

// declare facts about sets
fact {State = On + Off}
fact {VolumeState = Empty + Partiall + Full}
fact {Device = InLamp + Outlet + PetFeeder + Radiator + Vacuum + Lock + AC + OutLamp + LawnMover + Shutter}
fact {Sensor = Thermometer + Barometer + Photodetector + MotionDetector + WindDetector + Clock + PressureDetector + ManualDetector}

//declare facts about uniqueness
fact { all dev1 : Device, dev2 : Device | dev1.id = dev2.id <=> dev1 = dev2 }
fact { all sen1 : Sensor, sen2 : Sensor | sen1.id = sen2.id <=> sen1 = sen2 }

// each indoor device has a room assigned
fact { all dev : IndoorDevice, rum : dev.room | dev in rum.devices }
// each room is in some home
fact { all room : Room | some home : Home | room in home.rooms }
// each outlet has at most 2 slots
fact { all out : Outlet | out.size > 1 and out.size < 2  }
//home is made of rooms
fact { all hom : Home | #hom.rooms > 0 }
// each vacuum has a room to clean
fact { all vac : Vacuum | #vac.roomsToClean > 0 }
// feeders sensor values correspond to its state
fact { all feeder : PetFeeder, sensor : feeder.sensors | sensor.value = 100 => feeder.filling = Full }
fact { all feeder : PetFeeder, sensor : feeder.sensors | (sensor.value < 100 and sensor.value > 0) => feeder.filling = Partiall }
fact { all feeder : PetFeeder, sensor : feeder.sensors | sensor.value = 0 => feeder.filling = Empty }

////////////////////////////////////////ASSERTS

assert all_devices_have_unique_id {
	all dev1 : Device, dev2: Device | dev1 != dev2 <=> dev1.id != dev2.id
}
assert all_sensors_have_unique_id {
	all sen1 : Sensor, sen2: Sensor | sen1 != sen2 <=> sen1.id != sen2.id
}
assert all_devices_have_some_state {
	all dev : Device | some st : State | dev.state = st
}
assert all_devices_have_at_least_one_sensor {
	all dev : Device | some sen : Sensor | sen in dev.sensors
}
assert one_home_has_all_outdoor_devices {
	one hom : Home | all dev : OutdoorDevice | dev.home = hom
}
assert all_devices_are_in_a_room_in_the_house {
	all dev : IndoorDevice | some rum : Room | one home : Home | rum in dev.room and rum in home.rooms
}
assert if_room_has_device_device_has_room {
	all dev : IndoorDevice | some rum : Room | dev in rum.devices <=> rum in dev.room
}
assert all_rooms_are_dirty_or_clean {
	all rum : Room | some st : DirtyinessState | rum.state = st
}

////////////////////////////////////////CHECKS

check all_devices_have_unique_id for 5
check all_sensors_have_unique_id for 5
check all_devices_have_some_state for 5
check all_devices_have_at_least_one_sensor for 5
check one_home_has_all_outdoor_devices for 5
check all_devices_are_in_a_room_in_the_house for 5
check if_room_has_device_device_has_room for 5
check all_rooms_are_dirty_or_clean for 5

////////////////////////////////////////PREDICATES

pred turnOutLigthsOnAfterDark [sensor : Photodetector, light, lightN : OutLamp] {
	sensor in light.sensors and sensor in lightN.sensors
	sensor.value < 0 // 0 indicates edge between light and dark
	lightN.state = On
}

pred turnOutLightsOnAfterMotion [sensor : MotionDetector, light, lightN : OutLamp] {
	sensor in light.sensors and sensor in lightN.sensors
	sensor.value > 0 // 0 indicates edge moving image and still image
	lightN.state = On
}

pred turnOutLigthsOffAfterLight [sensor : Photodetector, light, lightN : OutLamp] {
	sensor in light.sensors and sensor in lightN.sensors
	sensor.value > 0 // 0 indicates edge between light and dark
	lightN.state = Off
}

pred cleanRoomsAtFivePM [sensor : Clock, vacuum, vacuumN : Vacuum] {
	sensor in vacuum.sensors
	sensor.value = 17 // 17 indicates 5PM
	vacuum.state = Off // vacuum is not running
	vacuumN.state = On
	all rum : Room | rum in vacuum.room => rum.state = Clean
}

pred turnOnAC [sensor : Thermometer, ac, acN : AC] {
	sensor in ac.sensors
	sensor.value > 25 // 25 indicates temperature above 25 degrees
	acN.state = On
}

pred turnOffAC [sensor : Thermometer, ac, acN : AC] {
	sensor in ac.sensors
	sensor.value < 25 // 25 indicates temperature above 25 degrees
	acN.state = Off
}

pred turnOnHeater [sensor : Thermometer, heater, heaterN : Radiator] {
	sensor in heater.sensors
	sensor.value < 15 // 15 indicates temperature below 15 degrees
	heaterN.state = On
}

pred turnOffHeater [sensor : Thermometer, heater, heaterN : Radiator] {
	sensor in heater.sensors
	sensor.value > 15 // 15 indicates temperature below 15 degrees
	heaterN.state = Off
}

pred turnOffInLightsAfterLight [sensor : Photodetector, light, lightN : InLamp] {
	sensor in light.sensors and sensor in lightN.sensors
	sensor.value > 5 // 5 indicates edge between readable light and non-readable light
	lightN.state = Off
}

pred switchLightsManually [sensor : ManualDetector, light, lightN : InLamp] {
	sensor in light.sensors and sensor in lightN.sensors
	sensor.value > 0 // non-zero value indicates manual input
	light.state = Off => lightN.state = On
	light.state = On => lightN.state = Off
}

pred feederGetsFilled [sensor, sensorN : PressureDetector, feeder, feederN : PetFeeder] {
	sensor in feeder.sensors
	sensorN in feederN.sensors
	feeder.state = Off => feederN.state = On
	feeder.state = On => feederN.state = On
	sensorN.value = 100
	feederN.filling = Full
}

////////////////////////////////////////Test predicates

turnOnLightsDarkOkay : check { 
	all sensor : Photodetector, light, lightN : OutLamp |
		turnOutLigthsOnAfterDark[sensor, light, lightN] => lightN.state = On
} for 5

turnOnLightsMotionOkay : check { 
	all sensor : MotionDetector, light, lightN : OutLamp |
		turnOutLightsOnAfterMotion[sensor, light, lightN] => lightN.state = On
} for 5

turnOffLightsLightOkay : check { 
	all sensor : Photodetector, light, lightN : OutLamp |
		turnOutLigthsOffAfterLight[sensor, light, lightN] => lightN.state = Off
} for 5

cleanRoomsOkay : check { 
	all sensor : Clock, vacuum, vacuumN : Vacuum |
		cleanRoomsAtFivePM[sensor, vacuum, vacuumN] => all rum : Room | rum in vacuum.room => rum.state = Clean and vacuumN.state = On
} for 5

turnOnACOkay : check { 
	all sensor : Thermometer, ac, acN : AC |
		turnOnAC[sensor, ac, acN] => acN.state = On
} for 5

turnOffACOkay : check { 
	all sensor : Thermometer, ac, acN : AC |
		turnOffAC[sensor, ac, acN] => acN.state = Off
} for 5

turnOnHeaterOkay : check { 
	all sensor : Thermometer, heater, heaterN : Radiator |
		turnOnHeater[sensor, heater, heaterN] => heaterN.state = On
} for 5

turnOffHeaterOkay : check { 
	all sensor : Thermometer, heater, heaterN : Radiator |
		turnOffHeater[sensor, heater, heaterN] => heaterN.state = Off
} for 5

turnOffInLightsAfterLightOkay : check { 
	all sensor : Photodetector, light, lightN : InLamp |
		turnOffInLightsAfterLight[sensor, light, lightN] => lightN.state = Off
} for 5

switchLightsManuallyOkay : check { 
	all sensor : ManualDetector, light, lightN : InLamp |
		(switchLightsManually[sensor, light, lightN] and light.state = On => lightN.state = Off) 
		and
		(switchLightsManually[sensor, light, lightN] and light.state = Off => lightN.state = On)
} for 5

feederGetsFilledOkay : check { 
	all sensor, sensorN : PressureDetector, feeder, feederN : PetFeeder |
		feederGetsFilled[sensor, sensorN, feeder, feederN] => feederN.state = On and sensorN.value = 100 and feederN.filling = Full
} for 5

pred myInst {}
run myInst for 10
run myInst for 10 but exactly 1 Home, exactly 3 Room, exactly 6 Device
