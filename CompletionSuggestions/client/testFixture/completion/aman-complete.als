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

// HAMSTERS derived relationships

fun parent : Task -> Task {
	{ a,b : Task | a in elems[b.subtasks] }
}

fun succ : Task -> Task {
	{ x, y : Task | some p : Task | x+y in elems[p.subtasks] and idxOf[p.subtasks,y] = idxOf[p.subtasks,x].next }
}

fact Tree {
	no Root.parent
	all t : Task-Root | one t.parent
	all t : Task | t not in t.^parent
}

fact WellFormed {
	all t : Composite | not lone elems[t.subtasks] and not hasDups[t.subtasks]
	all t : Choice+Disable+Suspend | no parent.t & Optional
	all t : Sequence | no succ.(parent.t) & Iterative
 	all t : Sequence+Concurrent | some parent.t - Optional
	all t : Erroneous | t in Input and some t.parent & Sequence
}

fact Behavior { no executed and no log and always {
	nop or (some t : Atomic | execute[t]) or (some t : Task | reset[t])
	enabled = { t : Task | {
		t.parent in enabled
		t in Atomic implies t.guard = True and (t in Erroneous or t not in done)
		some t.parent & Choice implies no (parent.(t.parent) - t) & running
		some t.parent & Sequence implies all x : ^succ.t | ((t in Erroneous or x in done) or (x in Optional and x not in running))
		some t.parent & Sequence implies no t.^succ & running and (t in Erroneous or no t.^succ & done)
		some t.parent & Disable implies no t.succ & (running + done)
		some t.parent & Suspend implies no t.succ & running
		}}
	running = { t : Task | t not in done and some ^parent.t & done }
	finished = { t : Task | {
		t in Atomic implies t in executed
		t not in Disable implies no parent.t & running
		t in Sequence implies (all t : parent.t - Optional | no t.^succ - Optional implies t in done)
		t in Concurrent implies parent.t - Optional in done
		t in Choice implies some parent.t & done
		t in Suspend implies parent.t - (parent.t).succ in done
		t in Disable implies parent.t - succ.(parent.t) in done
		}}
	done = { t : Task | t in finished - Iterative - (parent.Suspend).succ }
	}
}

fact {
	always Enabled = enabled & Atomic
}

pred nop {
	executed' = executed
	log' = log
}

pred execute [t : Atomic] {
	t in enabled
	executed' = executed + t

	all x : Sequence & t.parent | x.log' = x.log.add[t]

	all x : Sequence - t.parent {
		some parent.x & (finished' - finished)
		implies x.log' = x.log.add[parent.x & (finished' - finished)]
		else x.log' = x.log
	}
}

pred reset [t : Task] {
	t in enabled & (finished - done)
	executed' = executed - *parent.t
	all x : *parent.t | no x.log'
	all x : Sequence - *parent.t | x.log' = x.log
}

pred WF_Task[t:Task] {
	t in Atomic implies (eventually always (t in enabled) implies always eventually execute[t])
	eventually always (t in enabled and t in finished - done) implies always eventually reset[t]
}

pred WF {
	all t : Atomic | eventually always (t in enabled) implies always eventually execute[t]
	all t : Task | eventually always (t in enabled and t in finished - done) implies always eventually reset[t]
}

pred SF_Task[t:Task] {
	t in Atomic implies (always eventually (t in enabled) implies always eventually execute[t])
	always eventually (t in enabled and t in finished - done) implies always eventually reset[t]
}

pred SF {
	all t : Atomic | always eventually (t in enabled) implies always eventually execute[t]
	all t : Task | always eventually (t in enabled and t in finished - done) implies always eventually reset[t]
}

pred Complete {
	Root in done
}

pred Deadlock {
	no t : Atomic | t in enabled
 	no t : Task | t in enabled and t in finished - done
}

run HAMSTERS_Complete {
	no Erroneous and eventually Complete
}

run ErroneousComplete {
	some Erroneous and eventually Complete
}

assert HAMSTERS_NoDeadlock {
	no Erroneous
	implies
	always (guard.True = Atomic and not Complete implies not Deadlock)
}
// check HAMSTERS_NoDeadlock for 6 but 3 seq, 10 steps expect 0

// AMAN derived

fun showHolding : Plane {
	holding.label
}

fact {
	Iterative = ManageLS
	Optional = ChangeZoom+ModifyLS+BlockTimeSlot+SelectAircraftLabel+ClickHoldButton
	Input = ModifyLS+ModifyZoom+SelectAircraftLabel+ClickHoldButton+SelectSlot
}

// AMAN events

pred stutter {
	no t : Atomic | execute[t]

	radar' = radar
	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	holding' = holding
	selected' = selected
	blocked' = blocked
}

pred stopManageLS {
	execute[StopManageLS]

	zoom' = zoom

	no radar'
	no slot'
	no label'
	no holding'
	no displayed'
	no selected'
	no blocked'
}

pred monitorLS {
	execute[MonitorLS]

	radar' = radar
	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	holding' = holding
	selected' = selected
	blocked' = blocked
}

pred receiveRadarInformation {
	execute[ReceiveRadarInformation]

	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	holding' = holding
	selected' = selected
	blocked' = blocked
}

pred computeLS {
	execute[ComputeLS]

	slot'.Slot = radar
 	all s : Slot | lone slot'.s

	no Plane.slot' & blocked

	Plane <: holding' = holding & radar

	Slot <: holding' = Slot <: holding
	radar' = radar
	label' = label
	displayed' = displayed
	zoom' = zoom
	selected' = selected
	blocked' = blocked
}

pred displayLS {
	execute[DisplayLS] or execute[DisplayLSAfterZoom]

	displayed' = zoom.*prev
	label' = ~(slot :> displayed')
	Slot <: holding' = label.holding & displayed'

	radar' = radar
	slot' = slot
	zoom' = zoom
	Plane <: holding' = Plane <: holding
	selected' = selected
	blocked' = blocked
}

pred modifyZoom {
	execute[ModifyZoom]

	zoom' != zoom

	radar' = radar
	slot' = slot
	label' = label
	holding' = holding
	displayed' = displayed
	selected' = selected
	blocked' = blocked
}

pred modifyLS {
	execute[ModifyLS]

	some p : Slot.label, s : displayed - Plane.slot - blocked | slot' = slot ++ p->s
	label' = ~(slot' :> displayed)

	holding' = holding
	displayed' = displayed
	radar' = radar
	zoom' = zoom
	selected' = selected
	blocked' = blocked
}

pred selectAircraftLabel {
	execute[SelectAircraftLabel]

	some s : (Slot-holding).label-selected | Plane <: selected' = s

	Slot <: selected' = Slot <: selected
	radar' = radar
	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	holding' = holding
	blocked' = blocked
}

pred clickHoldButton {
	execute[ClickHoldButton]

	holding' = holding + Plane <: selected
	no Plane <: selected'

	Slot <: selected' = Slot <: selected
	radar' = radar
	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	blocked' = blocked
}

pred selectSlot {
	execute[SelectSlot]

	some s : displayed - blocked | Slot <: selected' = s

	Plane <: selected' = Plane <: selected
	radar' = radar
	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	holding' = holding
	blocked' = blocked
}

pred displaySlotBlocked {
	execute[DisplaySlotLocked]

	blocked' = blocked + Slot <: selected
	no Slot <: selected'

	Plane <: selected' = Plane <: selected
	radar' = radar
	slot' = slot
	label' = label
	displayed' = displayed
	zoom' = zoom
	holding' = holding
}

fact {
	displayed = zoom.*prev
	no radar
	no slot
	no label
	no holding
	no selected
	no blocked

	always {
		stutter or
		stopManageLS or
		receiveRadarInformation or
		computeLS or
		displayLS or
		modifyZoom or
		monitorLS or
		modifyLS or
		selectAircraftLabel or
		clickHoldButton or
		selectSlot or
		displaySlotBlocked
	}
}

pred AMAN10s {
	always eventually AMANAutonomousActivity in enabled
	implies
	always eventually AMANAutonomousActivity in running
}

// run Simulation {
// 	no Erroneous
// } for 3 but 6 seq, exactly 3 Plane, exactly 4 Slot, 20 steps expect 1

// run Complete {
// 	no Erroneous
// 	eventually Complete
// } for 3 but 6 seq, 20 steps expect 1

// run NeverComplete {
// 	no Erroneous
// 	WF
// 	SF_Task[AMANAutonomousActivity]
// 	always not Complete
// } for 3 but 6 seq, 20 steps expect 1

// run AllExecute {
// 	no Erroneous
// 	all t : Atomic | eventually execute[t]
// } for 3 but 6 seq, 20 steps expect 1

// run SomeHolding {
// 	no Erroneous
// 	eventually (some Slot & holding)
// } for 3 but 6 seq, 20 steps expect 1

// run AnyError {
// 	eventually (
// 		some st : Sequence |
// 			st in finished and
// 			st.log != st.subtasks
// 	)
// } for 3 but 6 seq, 20 steps expect 1

// run OmitError {
// 	eventually (
// 		some st : Sequence |
// 			st in finished and
// 			some i : seq/Int, x : Task | st.subtasks = insert[st.log,i,x]
// 	)
// } for 3 but 6 seq, 20 steps expect 1

// run RepeatError {
// 	eventually (
// 		some st : Sequence |
// 			st in finished and
// 			some i : seq/Int, x : Task | st.log = insert[st.subtasks,i,x]
// 	)
// } for 3 but 6 seq, 20 steps expect 1

// run ReorderError {
// 	eventually (
// 		some st : Sequence |
// 			st in finished and
// 			#st.log = #st.subtasks and
// 			elems[st.log] = elems[st.subtasks] and
// 			st.log != st.subtasks)
// } for 3 but 6 seq, 20 steps expect 1

// assert HoldingInRadar {
// 	no Erroneous implies always holding in radar
// }
// check HoldingInRadar for 3 but 6 seq, 20 steps expect 1

// assert LabelsInLS {
// 	no Erroneous implies always label in ~slot
// }
// check LabelsInLS for 3 but 6 seq, 20 steps expect 1

// assert NoLabelOverlap {
// 	no Erroneous implies
// 	always (all s : Slot | lone s.label)
// }
// check NoLabelOverlap for 3 but 6 seq, 20 steps expect 0

// assert NoLabelsBlockedA {
// 	no Erroneous implies
// 	always (no p : Plane | some label.p & blocked)
// }
// check NoLabelsBlockedA for 3 but 6 seq, 20 steps expect 1

// assert NoLabelsBlockedB {
// 	no Erroneous and
// 	WF implies always {
// 		eventually (no p : Plane | some label.p & blocked)
// 	}
// }
// check NoLabelsBlockedB for 3 but 6 seq, 20 steps expect 0

// pred DisplayChanges {
// 	label' != label or
//     holding' & Slot != holding & Slot or
// 	displayed' != displayed or
// 	selected' & Slot.label' != selected & Slot.label or
// 	selected' & displayed' != selected & displayed or
// 	blocked' & displayed' != blocked & displayed or
// 	zoom' != zoom
// }

// assert Feedback {
// 	no Erroneous and
// 	WF implies all t : Input | always (execute[t] implies eventually DisplayChanges)
// }
// check Feedback for 3 but 6 seq, 20 steps expect 0

// assert NoDeadlock {
// 	no Erroneous implies
// 	always (Root not in done implies not Deadlock)
// }
// check NoDeadlock for 3 but 6 seq, 20 steps expect 0

// assert SelectAvailable {
// 	no Erroneous and
// 	SF implies always (always (some (Slot-holding).label-selected) implies eventually (SelectAircraftLabel in enabled))
// }
// check SelectAvailable for 3 but 6 seq, 20 steps expect 0

// check AMAN_fairness {
//     WF implies AMAN10s
// } for 3 but 6 seq, 20 steps


run {}