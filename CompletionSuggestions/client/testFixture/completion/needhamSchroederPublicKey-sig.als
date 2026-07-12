open util/ordering[Time] as TO
sig Time { }

abstract sig Key {}

abstract sig Principal {
  knows: set Nonce -> Time,
  message: Message lone -> Time
}

abstract sig Nonce {}

one sig AliceNonce, BobNonce, EveNonce extends Nonce {}
one sig Server extends Principal {}

one sig Key_PA, Key_SA, Key_PB, Key_SB, Key_PS, Key_SS, Key_PE, Key_SE extends Key {}

one sig Message {
  sender: Principal lone -> Time,
  nonceA: Nonce lone -> Time,
  nonceB: Nonce lone -> Time,
  process: Process lone -> Time,
  key: Key lone -> Time,
  encryption: Key lone -> Time
}

abstract sig Process extends Principal {
  server_key: one Key,
  comm_key: Key lone -> Time,
  partner: lone Process,
  nonce: one Nonce,
  keys: set Key -> Time
}

one sig Eve extends Process {}

fact Eve_facts {
  all t: Time | Eve.comm_key.t = Key_PE
}

one sig Alice, Bob extends Process {}

fact AliceBob_facts {
  all p: Alice + Bob | {
    p.server_key = Key_PS
    no p.keys
  }
}
