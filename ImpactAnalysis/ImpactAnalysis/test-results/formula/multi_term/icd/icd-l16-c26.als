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
sig ModeOnMessage extends 
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
