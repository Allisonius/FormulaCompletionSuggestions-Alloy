open util/ordering[Slot]

// HAMSTERS (inlined)

abstract sig Task {}
abstract sig Atomic extends Task {
	var guard : lone True
}
one sig True {}
abstract sig Composite extends Task {
	subtasks : seq Task
}
abstract sig Disable, Suspend, Concurrent, Choice extends Composite {}

abstract sig Sequence extends Composite {
	var log : seq Task
}

one sig Root in Task {}
sig Iterative, Optional, Input in Task {}

sig Erroneous in Atomic {}

var sig executed, enabled, running, finished, done in Task {}

one sig Enabled in Atomic {}

// AMAN state model

sig Plane {
	var slot : lone Slot
}
var sig radar in Plane {}
var sig holding in Plane+Slot {}
var sig blocked in Slot {}

sig Slot {
	var label : set Plane
}
var sig zoom in Slot {}
fact {
	#zoom = 1
}
var sig displayed in Slot {}
var sig selected in Plane+Slot {}

// AMAN task model sigs

one sig ManageSector extends Disable {}
fact ManageSector_facts {
	all x : ManageSector | x.subtasks = 0->ManageLS + 1->StopManageLS
}
one sig StopManageLS extends Atomic {}
fact StopManageLS_facts {
	all x : StopManageLS | x.guard = True iff no radar
}
one sig ManageLS extends Suspend {}
fact ManageLS_facts {
	all x : ManageLS | x.subtasks = 0->ManageLandingSequenceLS + 1->AMANAutonomousActivity
}
one sig ManageLandingSequenceLS extends Concurrent {}
fact ManageLandingSequenceLS_facts {
	all x : ManageLandingSequenceLS | x.subtasks = 0->MonitorLS + 1->ChangeZoom + 2->ModifyLS + 3->BlockTimeSlot + 4->SelectAircraftLabel + 5->ClickHoldButton
}
one sig MonitorLS extends Atomic {}
fact MonitorLS_facts {
	all x : MonitorLS | x.guard = True
}
one sig ModifyLS extends Atomic {}
fact ModifyLS_facts {
	all x : ModifyLS | x.guard = True iff (some Slot.label and some displayed - Plane.slot - blocked)
}
one sig ChangeZoom extends Sequence {}
fact ChangeZoom_facts {
	all x : ChangeZoom | x.subtasks = 0->ModifyZoom + 1->DisplayLSAfterZoom
}
one sig ModifyZoom extends Atomic {}
fact ModifyZoom_facts {
	all x : ModifyZoom | x.guard = True iff some Slot - zoom
}
one sig DisplayLSAfterZoom extends Atomic {}
fact DisplayLSAfterZoom_facts {
	all x : DisplayLSAfterZoom | x.guard = True
}
one sig SelectAircraftLabel extends Atomic {}
fact SelectAircraftLabel_facts {
	all x : SelectAircraftLabel | x.guard = True iff (some (Slot-holding).label - selected)
}
one sig ClickHoldButton extends Atomic {}
fact ClickHoldButton_facts {
	all x : ClickHoldButton | x.guard = True iff one selected & Plane & displayed.label
}
one sig AMANAutonomousActivity extends Sequence {}
fact AMANAutonomousActivity_facts {
	all x : AMANAutonomousActivity | x.subtasks = 0->ReceiveRadarInformation + 1->ComputeLS + 2->DisplayLS
}
one sig ReceiveRadarInformation extends Atomic {}
one sig ComputeLS extends Atomic {}
one sig DisplayLS extends Atomic {}
fact ReceiveRadarInformation_ComputeLS_DisplayLS_facts {
	all x : ReceiveRadarInformation+ComputeLS+DisplayLS | x.guard = True
}
one sig BlockTimeSlot extends Sequence {}
fact BlockTimeSlot_facts {
	all x : BlockTimeSlot | x.subtasks = 0->SelectSlot + 1->DisplaySlotLocked
}
one sig SelectSlot extends Atomic {}
fact SelectSlot_facts {
	all x : SelectSlot | x.guard = True iff (some displayed - blocked)
}
one sig DisplaySlotLocked extends Atomic {}
fact DisplaySlotLocked_facts {
	all x : DisplaySlotLocked | x.guard = True iff one selected & Slot
}
