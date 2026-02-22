open util/ordering[Time] as trace
open util/ordering[Node] as ring

sig Time { }

abstract sig Event {
   pre:  Time,
   post: Time,
   cause: lone (Event - Null)
}

sig Null extends Event { } { no cause }

sig Node {
   succ: Node lone -> Time,
   succ2: Node lone -> Time,
   prdc: Node lone -> Time,
   bestSucc: Node lone -> Time 
}

abstract sig RingEvent extends Event { node: Node }
sig Join extends RingEvent { } { no cause }
sig Stabilize extends RingEvent { } { no cause  }
sig Notified extends RingEvent { newPrdc: Node } { some cause }
sig Fail extends RingEvent { } { no cause }
sig Flush extends RingEvent { } { no cause }
sig Update extends RingEvent { } { no cause }
sig Reconcile extends RingEvent { } { no cause }