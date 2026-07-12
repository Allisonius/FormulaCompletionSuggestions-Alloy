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
