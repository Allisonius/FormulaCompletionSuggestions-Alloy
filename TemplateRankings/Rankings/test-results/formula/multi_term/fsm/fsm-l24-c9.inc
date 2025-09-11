one sig FSM {
  start: set State,
  stop: set State
}

sig State {
  transition: set State
}

// Part (a)
fact OneStartAndStop_1 {
  // FSM only has one start state.
  one FSM.start
}

fact OneStartAndStop_2 {
  // FSM only has one stop state.
  one FSM.stop
}

// Part (b)
fact ValidStartAndStop_1 {
  // A state cannot be both a start state and a stop state.
  no FSM.
}

fact ValidStartAndStop_2 {
  // No transition ends at the start state.
  no transition.(FSM.start)
}

fact ValidStartAndStop_3 {
  // No transition begins at the stop state.
  no (FSM.stop).transition
}

// Part (c)
fact Reachability_1 {
  // All states are reachable from the start state.
  all n: State | n in FSM.start.*transition
}

fact Reachability_2 {
  // The stop state is reachable from any state.
  all n: State | FSM.stop in n.*transition 
}

run {} for 5