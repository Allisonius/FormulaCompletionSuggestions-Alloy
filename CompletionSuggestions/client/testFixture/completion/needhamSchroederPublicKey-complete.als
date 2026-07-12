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

pred init (t: Time) {
  no Eve.knows.t
  no Alice.comm_key.t
  no Bob.comm_key.t
  Alice.nonce = AliceNonce
  Bob.nonce = BobNonce
  Eve.nonce = EveNonce
  Alice.knows.t = Alice.nonce
  Bob.knows.t = Bob.nonce
  Message.encryption.t = Key_SA
  Message.sender.t = Server
  Message.process.t = Alice
  no Eve.keys.t
}

pred AliceRequestBob(t, tt: Time) {
  Alice.message.t.sender.t = Server
  Alice.message.t.process.t = Alice
  Alice.message.t.key.t != Key_PA
  let serverMsg = Server.message.tt |
    (serverMsg.sender.tt = Alice and
    no serverMsg.nonceA.tt and
    no serverMsg.nonceB.tt and
    serverMsg.process.tt = Bob and
    no serverMsg.key.tt and
    no serverMsg.encryption.tt)
  noProcChange[t, tt, Alice]
  noProcChange[t, tt, Bob]
  Eve.keys.tt = Eve.keys.t
}

pred ServerCommWithAlice(t, tt: Time) {
  Server.message.t.sender.t = Alice
  Server.message.t.process.t = Bob
  let aliceMsg = Alice.message.tt |
    (aliceMsg.sender.tt = Server and
    no aliceMsg.nonceA.tt and
    no aliceMsg.nonceB.tt and
    aliceMsg.process.tt = Bob and
    aliceMsg.key.tt = Key_PB and
    aliceMsg.encryption.tt = Key_SS)
  Alice.comm_key.tt = Key_PB
  Alice.knows.tt = Alice.knows.t
  noProcChange [t, tt, Bob]
  Eve.keys.tt = Eve.keys.t
}

pred AliceSendToBob (t, tt: Time) {
  Alice.message.t.sender.t = Server
  Alice.message.t.process.t = Bob
  let bobMsg = Bob.message.tt |
    (bobMsg.sender.tt = Alice and
    bobMsg.nonceA.tt = Alice.nonce and
    no bobMsg.nonceB.tt and
    bobMsg.process.tt = Alice and
    no bobMsg.key.tt and
    bobMsg.encryption.tt = Key_PB)
  Bob.comm_key.tt = Bob.message.tt.key.tt
  Bob.knows.tt = Bob.knows.t
  noProcChange[t, tt, Alice]
}

// attacker intercept here
pred EveSendToBob (t, tt: Time) {
  Alice.message.t.sender.t = Server
  Alice.message.t.process.t = Bob
  let bobMsg = Bob.message.tt |
    (bobMsg.sender.tt = Eve and
    bobMsg.nonceA.tt = Alice.nonce and
    no bobMsg.nonceB.tt and
    bobMsg.process.tt = Alice and
    no bobMsg.key.tt and
    bobMsg.encryption.tt = Key_PB)
  Bob.comm_key.tt = Bob.message.tt.key.tt
  Bob.knows.tt = Bob.knows.t
  noProcChange[t, tt, Alice]
}

pred BobRequestAlice (t, tt: Time) {
  (Bob.message.t.sender.t = Alice or Bob.message.t.sender.t = Eve)
  Bob.message.t.process.t = Alice
  some Bob.message.t.nonceA.t
  let serverMsg = Server.message.tt |
    (serverMsg.sender.tt = Bob and
    no serverMsg.nonceA.tt and
    no serverMsg.nonceB.tt and
    serverMsg.process.tt = Alice and
    no serverMsg.key.tt and
    serverMsg.encryption.tt = Bob.server_key)
  noProcChange[t, tt, Bob]
  noProcChange[t, tt, Alice]
}

pred ServerCommWithBob(t, tt: Time) {
  Server.message.t.sender.t = Bob
  Server.message.t.process.t = Alice
  let bobMsg = Bob.message.tt |
    (bobMsg.sender.tt = Server and
    no bobMsg.nonceA.tt and
    no bobMsg.nonceB.tt and
    bobMsg.process.tt = Alice and
    bobMsg.key.tt = Key_PA and
    bobMsg.encryption.tt = Key_SS)
  Bob.knows.tt = Bob.knows.t
  noProcChange [t, tt, Alice]
}

pred BobSendNoncesToAlice (t, tt: Time) {
  Bob.message.t.sender.t = Server
  Bob.message.t.process.t = Alice
  Bob.message.t.encryption.t = Key_SS
  Bob.comm_key.t = Key_PA
  let aliceMsg = Alice.message.tt |
    (aliceMsg.sender.tt = Bob and
    aliceMsg.nonceA.tt = Alice.nonce and
    aliceMsg.nonceB.tt = Bob.nonce and
    no aliceMsg.process.tt and
    no aliceMsg.key.tt and
    aliceMsg.encryption.tt = Key_PA)
  Alice.knows.tt = Alice.knows.t + Bob.nonce
  noProcChange[t, tt, Bob]
}

pred EveSendNoncesToAlice (t, tt: Time) {
  Bob.message.t.sender.t = Server
  Bob.message.t.process.t = Alice
  Bob.message.t.encryption.t = Key_SS
  Bob.comm_key.t = Key_PA
  let aliceMsg = Alice.message.tt |
    (aliceMsg.sender.tt = Eve and // attacker intercepts here
    aliceMsg.nonceA.tt = Alice.nonce and
    aliceMsg.nonceB.tt = Eve.nonce and
    no aliceMsg.process.tt and
    no aliceMsg.key.tt and
    aliceMsg.encryption.tt = Key_PA)
  Alice.knows.tt = Alice.knows.t
  noProcChange[t, tt, Bob]
}

pred AliceReplyNonceToSender (t, tt: Time) {
  (Alice.message.t.sender.t = Bob or Alice.message.t.sender.t = Eve)
  let bobOrEveMsg = Alice.message.t.sender.t.message.tt |
    (bobOrEveMsg.sender.tt = Alice and
    no bobOrEveMsg.nonceA.tt and
    bobOrEveMsg.nonceB.tt = Alice.message.t.nonceB.t and
    no bobOrEveMsg.process.tt and
    no bobOrEveMsg.key.tt and
    bobOrEveMsg.encryption.tt = Alice.message.t.sender.t.comm_key.t)
  Bob.knows.tt = Bob.knows.t
  Alice.message.t.sender.t.knows.tt = Alice.message.t.sender.t.knows.t
  noProcChange[t, tt, Alice]
}

pred EveSendNonceToBob (t, tt: Time) {
  Eve.message.t.sender.t = Alice
  some Eve.message.t.nonceB.t
  let bobMsg = Bob.message.tt |
    (bobMsg.sender.tt = Eve and
    no bobMsg.nonceA.tt and
    bobMsg.nonceB.tt = Eve.nonce and
    no bobMsg.process.tt and
    no bobMsg.key.tt and
    bobMsg.encryption.tt = Key_PB)
  Bob.knows.tt = Eve.nonce + Bob.knows.t
  noProcChange[t, tt, Alice]
}

pred StealAliceKey (t, tt: Time) {
  Key_SA in Eve.keys.t
  Alice.knows.tt = Alice.knows.t + Eve.nonce
}

pred StealBobKey (t, tt: Time) {
  Key_SB in Eve.keys.t
  Bob.knows.tt = Bob.knows.t + Eve.nonce
}

pred noProcChange (t, tt: Time, p: Process) {
  p.comm_key.tt = p.comm_key.t
  p.knows.tt = p.knows.t
}

fact Traces {
  first.init
  all t: Time - last | let tt = t.next |
    AliceRequestBob[t, tt]
    or ServerCommWithAlice[t, tt]
    or AliceSendToBob[t, tt]
    or EveSendToBob[t, tt]
    or BobRequestAlice[t, tt]
    or ServerCommWithBob[t, tt]
    or BobSendNoncesToAlice[t, tt]
    or EveSendNoncesToAlice[t, tt]
    or AliceReplyNonceToSender[t, tt]
    or EveSendNonceToBob[t, tt]
    or StealAliceKey[t, tt]
    or StealBobKey[t, tt]
    or init[tt]
}

fact alwaysDifferentSender {
  all t: Time, tt: t.next | Message.sender.t != Message.sender.tt
}

fact serverDoesNotLearn {
  all t: Time, tt: t.next | Server.knows.tt = Server.knows.t
}

fact diffNonces {
  Alice.nonce != Bob.nonce
  Bob.nonce != Eve.nonce
  Alice.nonce != Eve.nonce
}

fact neverForget {
  all t: Time, tt: t.next, p: Principal | #p.knows.tt >= #p.knows.t
}

fact attackerFrame {
  all t: Time, tt: t.next | no Eve.message.t implies Eve.knows.tt = Eve.knows.t
}

fact onlyOneMessagePerPrincipal {
  all t: Time {
    some p: Principal {
      some p.message.t && no (Principal - p).message.t
    }
  }
}

pred relHappensBefore(t: Time, tt: Time) {
  t.lt[tt]
}

/**
pred manInTheMiddle (t: Time, tt: Time) {
  some p, pp: Process {
    relHappensBefore[t,tt]
    p.message.t.sender.t != Eve &&
    p.message.t.sender.tt = Eve &&
    p.message.t.nonceA.t = pp.message.tt.nonceA.tt &&
    p.message.t.nonceB.t = pp.message.tt.nonceB.tt &&
    p.message.t.process.t = pp.message.tt.process.tt &&
    p.message.t.key.t = pp.message.tt.key.tt &&
    p.message.t.encryption.t != pp.message.tt.encryption.tt
  }
}
*/

pred aManInTheMiddle (t: Time, tt: Time) {
  t = tt.prev
  Eve.message.t.sender.t != Eve &&
  Alice.message.t.sender.tt = Eve &&
  Eve.message.t.nonceA.t = Alice.message.tt.nonceA.tt &&
  Eve.message.t.nonceB.t = Alice.message.tt.nonceB.tt &&
  Eve.message.t.process.t = Alice.message.tt.process.tt &&
  Eve.message.t.key.t = Alice.message.tt.key.tt &&
  Eve.message.t.encryption.t != Alice.message.tt.encryption.tt
}

pred bManInTheMiddle (t: Time, tt: Time) {
  t = tt.prev
  Eve.message.t.sender.t != Eve &&
  Bob.message.t.sender.tt = Eve &&
  Eve.message.t.nonceA.t = Bob.message.tt.nonceA.tt &&
  Eve.message.t.nonceB.t = Bob.message.tt.nonceB.tt &&
  Eve.message.t.process.t = Bob.message.tt.process.tt &&
  Eve.message.t.key.t = Bob.message.tt.key.tt &&
  Eve.message.t.encryption.t != Bob.message.tt.encryption.tt
}

pred relKeyinKey [k1, k2: Key] {
  k1 in k2
}

pred relEqualsKey[x: Key, y: Key] {
  x = y
}

pred relEqualsMessage[x: Message, y: Message] {
  x = y
}

pred relEqualsProcess[x: Process, y: Process] {
  x = y
}

pred relNotEqualsTime[x: Time, y: Time] {
  !(x = y)
}

pred relNonceInNonce[n1, n2: Nonce] {
  n1 in n2
}

/*
classification by hand

// models eve stealing alices secret, then communicating with bob
// and having bob believe the nonce
pred characterize_EveStealsAliceSecret {
  some t: Time {
    Key_SA in Eve.keys.t
  }

}  fact { !characterize_EveStealsAliceSecret }

pred characterize_EveStealsBobSecret {
  some t: Time {
    Key_SB in Eve.keys.t
  }

}  fact { !characterize_EveStealsBobSecret }
*/

// constrain counterexample space to only manInTheMiddle attacks
pred manInTheMiddleConstraint[t1, t2, t3, t4, t5, t6: Time] {
  aManInTheMiddle[t1, t2] &&
  bManInTheMiddle[t3, t4] &&
  aManInTheMiddle[t5, t6]
}

pred EventuallyAliceAndBobCommunicateWithEachOther {
  all t: Time |
    not(Eve.nonce in Alice.knows.t) and not(Eve.nonce in Bob.knows.t)
}

assert CheckEventuallyAliceAndBobCommunicateWithEachOther {
  EventuallyAliceAndBobCommunicateWithEachOther
} check CheckEventuallyAliceAndBobCommunicateWithEachOther for 9
