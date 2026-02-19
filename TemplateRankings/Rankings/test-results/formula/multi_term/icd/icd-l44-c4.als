module ebs
open util/ordering[State] as ord
sig Joules {}
one sig InitialJoulesToDeliver extends Joules {}
abstract sig Role {}
one sig Cardiologist, Patient extends Role {}
sig Principal {
  roles : set Role
}
abstract sig Message {
  source : Principal
}
sig ChangeSettingsMessage extends Message {
  joules_to_deliver : Joules
}
sig ModeOnMessage extends Message {
}
abstract sig Mode {}
one sig ModeOn, ModeOff extends Mode {}
abstract sig Action {
  who : Principal
}
sig SendModeOn, RecvModeOn,
    SendChangeSettings, RecvChangeSettings
    extends Action {}
one sig AttackerAction extends Action {}
one sig DummyInitialAction extends Action {}
sig State {
  network : lone Message,
  icd_mode : Mode,
  impulse_mode : Mode,
  joules_to_deliver : Joules,
  authorised_card : Principal,
  last_action : Action
}

fact {
  all s : State | lone s.network
}
pred Init[s : State] {
  no s.network and s.icd_mode = ModeOff and s.impulse_mode = ModeOff 
  and s.joules_to_deliver = InitialJoulesToDeliver and 
  Cardiologist in s.authorised_card.roles and
  s.
}
pred send_mode_on[s, ss : State] {
  some m : ModeOnMessage | m.source = s.authorised_card and
  ss.network = s.network + m and
  ss.icd_mode = s.icd_mode and
  ss.impulse_mode = s.impulse_mode and
  ss.joules_to_deliver = s.joules_to_deliver and
  ss.authorised_card = s.authorised_card and
  ss.last_action in SendModeOn and
  ss.last_action.who = m.source
}
pred recv_mode_on[s, ss : State] {
  some m : ModeOnMessage | m.source = s.authorised_card and s.network = m
  no ss.network and
  ss.icd_mode = ModeOn and
  ss.impulse_mode = ModeOn and
  ss.joules_to_deliver = s.joules_to_deliver and
  ss.authorised_card = s.authorised_card and
  ss.last_action in  RecvModeOn and
  ss.last_action.who = s.network.source
}
pred send_change_settings[s, ss : State] {
  some m : ChangeSettingsMessage | m.source = s.authorised_card and
  ss.network = s.network + m and
  ss.icd_mode = s.icd_mode and
  ss.impulse_mode = s.impulse_mode and
  ss.joules_to_deliver = s.joules_to_deliver and
  ss.authorised_card = s.authorised_card and
  ss.last_action in  SendChangeSettings and
  ss.last_action.who = m.source
}
pred recv_change_settings[s, ss : State] {
  some m :  ChangeSettingsMessage | m.source = s.authorised_card and 
  s.network = m and s.icd_mode = ModeOff and s.impulse_mode = ModeOff
  no ss.network and
  ss.icd_mode = s.icd_mode and
  ss.impulse_mode = s.impulse_mode and
  ss.joules_to_deliver = s.network.joules_to_deliver and
  ss.authorised_card = s.authorised_card and
  ss.last_action in  RecvChangeSettings and
  ss.last_action.who = s.network.source
}
pred attacker_action[s, ss : State] {
  ss.icd_mode = s.icd_mode and
  ss.joules_to_deliver = s.joules_to_deliver and
  ss.impulse_mode = s.impulse_mode and
  ss.authorised_card = s.authorised_card and
  ss.last_action = AttackerAction
}
pred state_transition[s, ss : State] {
  send_mode_on[s,ss]
  or recv_mode_on[s,ss]
  or send_change_settings[s,ss]
  or recv_change_settings[s,ss]
  or attacker_action[s,ss]
}
fact state_transition_ord {
  all s: State, ss: ord/next[s] {
    state_transition[s,ss] and ss != s
  }
}
fact init_state {
  all s: ord/first {
    Init[s]
  }
}
assert icd_never_off_after_on {
    all s : State | all ss : ord/nexts[s] | 
      s.icd_mode = ModeOn implies ss.icd_mode = ModeOn
}
check icd_never_off_after_on for 10 expect 0
pred inv[s : State] {
     s.icd_mode = s.impulse_mode
}
assert inv_always {
  inv[ord/first] and all s : ord/nexts[ord/first] | inv[s]
}
check inv_always for 10 expect 0
assert unexplained_assertion {
  all s : State | (all ss : State | ss.last_action not in AttackerAction) =>
      s.last_action in RecvChangeSettings =>
      Patient not in s.last_action.who.roles
}
check unexplained_assertion for 5
assert turns_on_safe {
}
check turns_on_safe for 5 but 8 State
