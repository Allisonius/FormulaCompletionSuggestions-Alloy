/*
 * Elevator system SPL based on the benchmarks from the paper "Symbolic Model
 * Checking of Software Product Lines" by A. Classen and A. Legay, itself adapted
 * from "Feature integration using a feature construct" by M. Plath and M. Ryan.
 *
 * author: Electrum team, 03/2016
 */
open util/ordering[Floor] as fl
open trace[State]

module Lift

sig State {}

fact { infinite }

// ---- Signatures ----

abstract sig Feature {}
one sig FEmpty, FThird, FOverload, FIdle, FExecutive, FPark extends Feature {}
sig Product in Feature {}

abstract sig Load {}
one sig Empty, Normal, Third, Overload extends Load {}

abstract sig Floor {}

one sig F1 extends Floor {}
one sig F2 extends Floor {}
one sig F3 extends Floor {}

fact F1_facts { F1 = fl/first }
fact F3_facts { F3 = fl/last }

abstract sig Button {
  floor : Floor,
  pressed : set State
}

abstract sig LandingButton, LiftButton extends Button {}

one sig LB1 extends LandingButton {}
one sig LB2 extends LandingButton {}
one sig LB3 extends LandingButton {}
one sig IB1 extends LiftButton {}
one sig IB2 extends LiftButton {}
one sig IB3 extends LiftButton {}

fact LB1_facts { LB1.floor = F1 }
fact LB2_facts { LB2.floor = F2 }
fact LB3_facts { LB3.floor = F3 }
fact IB1_facts { IB1.floor = F1 }
fact IB2_facts { IB2.floor = F2 }
fact IB3_facts { IB3.floor = F3 }

one sig Lift {
  Open : set State,
  Up : set State,
  current : Floor one -> State,
  load : Load one -> State
}

fact Lift_facts {
  FEmpty not in Product => Empty not in Lift.load.State
  FThird not in Product => Third not in Lift.load.State
  FOverload not in Product => Overload not in Lift.load.State
}

abstract sig Event {
  pre, pos : State
}

abstract sig ClosedEvent extends Event {
  bs : set Button
}

fact ClosedEvent_facts {
  all ce : ClosedEvent | {
    no ce.bs & pressed.(ce.pre)
    ce.pre not in Lift.Open
    Lift.load.(ce.pre) = Lift.load.(ce.pos)
    pressed.(ce.pos) = pressed.(ce.pre) + ce.bs
    Lift.load.(ce.pre) = Empty => no ce.bs & LiftButton
  }
}

sig Idle extends ClosedEvent {}

fact Idle_facts {
  all i : Idle | {
    idle[i.pre]
    FPark in Product => Lift.current.(i.pos) = parkLift[i.pre]
                     else Lift.current.(i.pos) = Lift.current.(i.pre)
    i.pos in Lift.Open iff i.pre in Lift.Open
    i.pos in Lift.Up iff i.pre in Lift.Up
  }
}

sig Move extends ClosedEvent {}

fact Move_facts {
  all m : Move | {
    some LiftCall[m.pre] + LandingCall[m.pre]
    Lift.current.(m.pos) = moveLift[m.pre]
    m.pos in Lift.Open iff willOpen[m.pos]
    m.pos in Lift.Up iff m.pre in Lift.Up
  }
}

sig OpenedEvent extends Event {
  bs : set Button
}

fact OpenedEvent_facts {
  all oe : OpenedEvent | {
    no oe.bs & pressed.(oe.pre)
    no oe.bs & floor.(Lift.current.(oe.pre))
    oe.pre in Lift.Open
    oe.pos in Lift.Up iff oe.pre in Lift.Up
    Lift.current.(oe.pos) = Lift.current.(oe.pre)
    ((Overload in Lift.load.(oe.pos)) || (FIdle in Product && idle[oe.pos])) => oe.pos in Lift.Open else oe.pos not in Lift.Open
    //  no floor.(Lift.current.(oe.pre)) & pressed.(oe.pos)
    let del = Empty in Lift.load.(oe.pos) => LiftButton else none |
      (pressed.(oe.pre) - del) - floor.(Lift.current.(oe.pre)) + oe.bs = pressed.(oe.pos)
    //  (pressed.(oe.pre) - del) - floor.(Lift.current.(oe.pre)) in pressed.(oe.pos)
  }
}

sig ChangeDir extends ClosedEvent {}

fact ChangeDir_facts {
  all cd : ChangeDir | {
    !idle[cd.pre]
    no LiftCall[cd.pre] + LandingCall[cd.pre]
    not (cd.pos in Lift.Up iff cd.pre in Lift.Up)
    cd.pos in Lift.Open iff cd.pre in Lift.Open
    Lift.current.(cd.pre) = Lift.current.(cd.pos)
  }
}

// ---- Functions and predicates ----

pred willOpen[s : State] {
  let //filter = (Third = Lift.load.s && some LiftButton & pressed.s) => LiftButton else univ,
       extra = FIdle in Product => idle[s] else some none//,
      //executive = FExecutive in Product => F3 in (pressed.s).floor && F3 not in Lift.current.s else some none
    | (Lift.current.s in (LiftCall[s] + LandingCall[s]) || extra)
}

fun moveLift[s : State] : lone Floor {
  Lift.current.s != max[Floor] && s in Lift.Up => next[Lift.current.s] else
  Lift.current.s != min[Floor] && s not in Lift.Up => prev[Lift.current.s] else
  Lift.current.s
}

fun parkLift[s : State] : lone Floor {
  Lift.current.s != min[Floor] => prev[Lift.current.s] else Lift.current.s
}

// the next lift landing button in the current direction
fun LiftCall[s : State] : set Floor {
  (FExecutive in Product && F3 in (pressed.s).floor) => F3 & nextFloors[s] else
  calledFloors[s, LiftButton] & nextFloors[s]
}

// the next pressed landing button in the current direction
fun LandingCall[s : State] : set Floor {
  (FExecutive in Product && F3 in (pressed.s).floor) => F3 & nextFloors[s] else
  (Third = Lift.load.s && some LiftButton & pressed.s) => none else
  calledFloors[s, LandingButton] & nextFloors[s]
}

// the subset of bs that is currently pressed
fun calledFloors[s : State, bs : set Button] : set Floor {
  (bs & pressed.s).floor
}

// succeeding floors in the current direction
fun nextFloors[s : State] : set Floor {
  (s in Lift.Up) => nextFloorsUp[s]
                 else nextFloorsDown[s]
}

fun nextFloorsUp[s : State] : set Floor {
  //  Lift.current.s = last => none else
  (Lift.current.s).*fl/next
}

fun nextFloorsDown[s : State] : set Floor {
  //  Lift.current.s = first => none else
  (Lift.current.s).*fl/prev
}

pred idle[s : State] {
  no pressed.s
}

pred init[s : State] {
  Lift.current.s = F1
  s in Lift.Open
  s in Lift.Up
  Lift.load.s = Normal
  no pressed.s
}

fact Trace {
  init[first]
  all s : State | (one e : Event | e.pre = s && e.pos = s.next)
}

// ---- Properties ----

// AG (p => AF q)
pred prop1 {
  all s : State | LB3 in pressed.s => some ss : s.future | Lift.current.ss = F3 && ss in Lift.Open
  all s : State | LB2 in pressed.s => some ss : s.future | Lift.current.ss = F2 && ss in Lift.Open
  all s : State | LB1 in pressed.s => some ss : s.future | Lift.current.ss = F1 && ss in Lift.Open
}

// EF (p && EG q)
pred prop11 {
  some s : State | LB2 in pressed.s && all ss : s.future | not (Lift.current.ss = F2 && ss in Lift.Open && ss not in Lift.Up)
}

// AG (p => AF q)
pred prop2 {
  all s : State | IB3 in pressed.s => some ss : s.future | Lift.current.ss = F3 && ss in Lift.Open
  all s : State | IB2 in pressed.s => some ss : s.future | Lift.current.ss = F2 && ss in Lift.Open
  all s : State | IB1 in pressed.s => some ss : s.future | Lift.current.ss = F1 && ss in Lift.Open
}

// AG (p => A q U r)
pred prop3a {
  all s : State | Lift.current.s = F2 && IB3 in pressed.s && s in Lift.Up =>
    some ss : s.future | Lift.current.ss = F3 && all sss : upto[s, ss] | sss in Lift.Up
}

// AG (p => A q U r)
pred prop3b {
  all s : State | Lift.current.s = F3 && IB1 in pressed.s && s not in Lift.Up =>
    some ss : s.future | Lift.current.ss = F1 && all sss : upto[s, ss] | sss not in Lift.Up
}

// EF (p && EG q)
pred prop4 {
  some s : State | s not in Lift.Open && all ss : s.future | ss not in Lift.Open
}

// EF p
pred prop5a {
  all s : State | not (Lift.current.s = F1 && idle[s] && s not in Lift.Open)
}

// AG (p => EG q) (invalid)
pred prop5b {}

// EF p
pred prop5part {}

// EF p
pred prop5c {
  all s : State | not (Lift.current.s = F2 && idle[s] && s not in Lift.Open)
}

// AG (p => EG q) (invalid)
pred prop5d {}

// EF (p && EG q)
pred prop5e {}

// EF (p && A q U r) (invalid)
pred prop55 {}

// EF p
pred prop6 {
  some s : State | Lift.current.s = F2 && IB2 not in pressed.s && s in Lift.Up && s in Lift.Open
}

// EF p
pred prop7 {
  some s : State | Lift.current.s = F2 && IB2 not in pressed.s && s not in Lift.Up && s in Lift.Open
}

check B1 {no Product => prop1} for 0 but 9 State, 9 Event expect 0
check E1 {Product = FEmpty => prop1} for 0 but 9 State, 9 Event expect 0
check O1 {Product = FOverload => prop1} for 0 but 5 State, 5 Event expect 1
check T1 {Product = FThird => prop1} for 0 but 9 State, 9 Event expect 1
check I1 {Product = FIdle => prop1} for 0 but 9 State, 9 Event expect 0
check X1 {Product = FExecutive => prop1} for 0 but 9 State, 9 Event expect 1
check P1 {Product = FPark => prop1} for 0 but 9 State, 9 Event expect 0
check EO1 {Product = FEmpty + FOverload => prop1} for 0 but 9 State, 9 Event expect 1
check A1 {prop1} for 0 but 9 State, 9 Event expect 1

run B11 {no Product && prop11} for 0 but 9 State, 9 Event expect 1
run E11 {Product = FEmpty && prop11} for 0 but 9 State, 9 Event expect 1
run O11 {Product = FOverload && prop11} for 0 but 9 State, 9 Event expect 1
run T11 {Product = FThird && prop11} for 0 but 9 State, 9 Event expect 1
run I11 {Product = FIdle && prop11} for 0 but 9 State, 9 Event expect 1
run X1 {Product = FExecutive && prop1} for 0 but 9 State, 9 Event expect 1
run EO11 {Product = FEmpty + FOverload && prop11} for 0 but 9 State, 9 Event expect 1
run A11 {prop11} for 0 but 9 State, 9 Event expect 1
check A111 {not prop11} for 0 but 9 State, 9 Event expect 1

check B2 {no Product => prop2} for 0 but 9 State, 9 Event expect 0
check E2 {Product = FEmpty => prop2} for 0 but 9 State, 9 Event expect 1
check O2 {Product = FOverload => prop2} for 0 but 9 State, 9 Event expect 1
check T2 {Product = FThird => prop2} for 0 but 9 State, 9 Event expect 0
check I2 {Product = FIdle => prop2} for 0 but 9 State, 9 Event expect 0
check X2 {Product = FExecutive => prop2} for 0 but 9 State, 9 Event expect 1
check P2 {Product = FPark => prop2} for 0 but 9 State, 9 Event expect 0
check EO2 {Product = FEmpty + FOverload => prop2} for 0 but 9 State, 9 Event expect 1
check A2 {prop2} for 0 but 9 State, 9 Event expect 1

check B3a {no Product => prop3a} for 0 but 9 State, 9 Event expect 0
check E3a {Product = FEmpty => prop3a} for 0 but 9 State, 9 Event expect 1
check O3a {Product = FOverload => prop3a} for 0 but 9 State, 9 Event expect 1
check T3a {Product = FThird => prop3a} for 0 but 9 State, 9 Event expect 1
check I3a {Product = FIdle => prop3a} for 0 but 9 State, 9 Event expect 1
check X3a {Product = FExecutive => prop3a} for 0 but 9 State, 9 Event
check P3a {Product = FPark => prop3a} for 0 but 9 State, 9 Event
check EO3a {Product = FEmpty + FOverload => prop3a} for 0 but 9 State, 9 Event expect 1
check A3a {prop3a} for 0 but 9 State, 9 Event expect 1

/*check B3b {no Product => prop3b} for 0 but 9 State, 9 Event expect 0
check E3b {Product = FEmpty => prop3b} for 0 but 9 State, 9 Event expect 1
check O3b {Product = FOverload => prop3b} for 0 but 9 State, 9 Event expect 1
check T3b {Product = FThird => prop3b} for 0 but 9 State, 9 Event expect 1
check I3b {Product = FIdle => prop3b} for 0 but 9 State, 9 Event expect 1
check EO3b {Product = FEmpty + FOverload => prop3b} for 0 but 9 State, 9 Event expect 1
check A3b {prop3b} for 0 but 9 State, 9 Event expect 1

run B4 {no Product => prop4} for 0 but 9 State, 9 Event expect 1
run E4 {Product = FEmpty => prop4} for 0 but 9 State, 9 Event expect 1
run O4 {Product = FOverload => prop4} for 0 but 9 State, 9 Event expect 1
run T4 {Product = FThird => prop4} for 0 but 9 State, 9 Event expect 1
run I4 {Product = FIdle => prop4} for 0 but 9 State, 9 Event expect 1
run EO4 {Product = FEmpty + FOverload => prop4} for 0 but 9 State, 9 Event expect 1
run A4 {prop4} for 0 but 9 State, 9 Event expect 1

run B5a {no Product => prop5a} for 0 but 9 State, 9 Event expect 1
run E5a {Product = FEmpty => prop5a} for 0 but 9 State, 9 Event expect 1
run O5a {Product = FOverload => prop5a} for 0 but 9 State, 9 Event expect 1
run T5a {Product = FThird => prop5a} for 0 but 9 State, 9 Event expect 1
run I5a {Product = FIdle => prop5a} for 0 but 9 State, 9 Event expect 1
run EO5a {Product = FEmpty + FOverload => prop5a} for 0 but 9 State, 9 Event expect 1
run A5a {prop5a} for 0 but 9 State, 9 Event expect 1

run B5c {no Product => prop5c} for 0 but 9 State, 9 Event expect 1
run E5c {Product = FEmpty => prop5c} for 0 but 9 State, 9 Event expect 1
run O5c {Product = FOverload => prop5c} for 0 but 9 State, 9 Event expect 1
run T5c {Product = FThird => prop5c} for 0 but 9 State, 9 Event expect 1
run EO5c {Product = FEmpty + FOverload => prop5c} for 0 but 9 State, 9 Event expect 1
run A5c {prop5c} for 0 but 9 State, 9 Event expect 1

run B6 {no Product && prop6} for 0 but 9 State, 9 Event expect 1
run E6 {Product = FEmpty && prop6} for 0 but 9 State, 9 Event expect 1
run O6 {Product = FOverload && prop6} for 0 but 9 State, 9 Event expect 1
run T6 {Product = FThird && prop6} for 0 but 9 State, 9 Event expect 1
run I6 {Product = FIdle && prop6} for 0 but 9 State, 9 Event expect 1
run X6 {Product = FIdle && prop6} for 0 but 9 State, 9 Event expect 1
run P6 {Product = FIdle && prop6} for 0 but 9 State, 9 Event expect 1
run EO6 {Product = FEmpty + FOverload && prop6} for 0 but 9 State, 9 Event expect 1
run A6 {prop6} for 0 but 9 State, 9 Event expect 1

run B7 {no Product && prop7} for 0 but 9 State, 9 Event expect 1
run E7 {Product = FEmpty && prop7} for 0 but 9 State, 9 Event expect 1
run O7 {Product = FOverload && prop7} for 0 but 9 State, 9 Event expect 1
run T7 {Product = FThird && prop7} for 0 but 9 State, 9 Event expect 1
run I7 {Product = FIdle && prop7} for 0 but 9 State, 9 Event expect 1
run X7 {Product = FIdle && prop7} for 0 but 9 State, 9 Event expect 1
run P7 {Product = FIdle && prop7} for 0 but 9 State, 9 Event expect 1
run EO7 {Product = FEmpty + FOverload && prop7} for 0 but 9 State, 9 Event expect 1
run A7 {prop7} for 0 but 9 State, 9 Event expect 1

// #Button = 2x #Floor

run {Product = FPark && some s: State | idle[s] && Lift.current.s = F3 && all ss:s.future | idle[ss] } for 0 but 9 State, 9 Event*/
