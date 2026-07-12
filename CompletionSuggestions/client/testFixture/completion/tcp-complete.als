open util/ordering[Time] as TO

sig Time { }

abstract sig Message {
	sender: Process lone -> Time
}

one sig SYN, ACK, SYN_ACK, FIN, INIT extends Message {}

abstract sig Channel {
	msg: Message one -> Time
}

one sig AtoB, BtoA extends Channel {}

abstract sig ProtocolState {}

one sig ClosedState extends ProtocolState {}
one sig ListenState extends ProtocolState {}
one sig SynSentState extends ProtocolState {}
one sig SynRecState extends ProtocolState {}
one sig EstState extends ProtocolState {}
one sig FinW1State extends ProtocolState {}
one sig ClosedWaitState extends ProtocolState {}
one sig FinW2State extends ProtocolState {}
one sig ClosingState extends ProtocolState {}
one sig LastAckState extends ProtocolState {}
one sig TimeWaitState extends ProtocolState {}
one sig EndState extends ProtocolState {}
one sig AttackerState extends ProtocolState {}

abstract sig Process {
	state: ProtocolState one -> Time,
	readChannel: one Channel,
	writeChannel: one Channel
}

one sig Attacker extends Process {}

abstract sig Participant extends Process {
	read: Message lone -> Time
}
one sig TCP_A extends Participant {}

one sig TCP_B extends Participant {}

pred HandleClosed(t, tt: Time, p: Process) {
	p.state.t = ClosedState
	p.read.t = p.read.tt
	((p.state.tt = ListenState and
	  noChannelChange[t, tt])
	 iff not
	 (p.state.tt = SynSentState and
	  p.writeChannel.msg.tt = SYN and
	  p.writeChannel.msg.tt.sender.tt = p and
	  thisChannelNoChange[t, tt, p.readChannel]))
}

pred HandleListen(t, tt: Time, p: Process) {
	p.state.t = ListenState
	((p.readChannel.msg.t = SYN and
	  p.read.tt = SYN and
	  p.read.tt.sender.tt = SYN.sender.t and
	  p.state.tt = SynRecState and
	  p.writeChannel.msg.tt = SYN_ACK and
	  p.writeChannel.msg.tt.sender.tt = p and
	  thisChannelNoChange[t, tt, p.readChannel])
	 iff not
	 (p.state.tt = ClosedState and
	  noChannelChange[t, tt] and
	  p.read.t = p.read.tt))
}

pred HandleSynSent(t, tt: Time, p: Process) {
	p.state.t = SynSentState
	((p.readChannel.msg.t = SYN and
	  p.read.tt = SYN and
	  p.read.tt.sender.tt = SYN.sender.t and
	  p.state.tt = SynRecState and
	  p.writeChannel.msg.tt = SYN_ACK and
	  p.writeChannel.msg.tt.sender.tt = p and
	  thisChannelNoChange[t, tt, p.readChannel])
	 iff not
	 (p.readChannel.msg.t = SYN_ACK and
	  p.read.tt = SYN_ACK and
	  p.read.tt.sender.tt = SYN_ACK.sender.t and
	  p.state.tt = EstState and
	  p.writeChannel.msg.tt = SYN_ACK and
	  p.writeChannel.msg.tt.sender.tt = p and
	  thisChannelNoChange[t, tt, p.readChannel])
	 iff not
	 (p.state.tt = ClosedState and
	  noChannelChange[t, tt] and
	  p.read.t = p.read.tt))
}

pred HandleSynRec(t, tt: Time, p: Process) {
	p.state.t = SynRecState
	noChannelChange[t, tt]
	((p.readChannel.msg.t = SYN_ACK and
	  p.read.tt = SYN_ACK and
	  p.read.tt.sender.tt = SYN_ACK.sender.t and
	  p.state.tt = EstState))
}

pred HandleEstablished(t, tt: Time, p: Process) {
	p.state.t = EstState
	((p.writeChannel.msg.tt = FIN and
	  p.writeChannel.msg.tt.sender.tt = p and
	  p.state.tt = FinW1State and
	  p.read.t = p.read.tt and
	  thisChannelNoChange[t, tt, p.readChannel])
	 iff not
	 (p.readChannel.msg.t = FIN and
	  p.read.tt = FIN and
	  p.read.tt.sender.tt = FIN.sender.t and
	  p.state.tt = ClosedWaitState and
	  p.writeChannel.msg.tt = ACK and
	  p.writeChannel.msg.tt.sender.tt = p and
	  thisChannelNoChange[t, tt, p.readChannel]))
}

pred HandleFinWait1(t, tt: Time, p: Process) {
	p.state.t = FinW1State
	((p.readChannel.msg.t = FIN and
	  p.read.tt = FIN and
	  p.read.tt.sender.tt = FIN.sender.t and
	  p.state.tt = ClosingState and
	  p.writeChannel.msg.tt = ACK and
	  p.writeChannel.msg.tt.sender.tt = p and
	  thisChannelNoChange[t, tt, p.readChannel])
	 iff not
	 (p.readChannel.msg.t = ACK and
	  p.read.tt = ACK and
	  p.read.tt.sender.tt = ACK.sender.t and
	  p.state.tt = FinW2State and
	  noChannelChange[t, tt]))
}

pred HandleClosedWait(t, tt: Time, p: Process) {
	p.state.t = ClosedWaitState
	p.read.t = p.read.tt
	((p.writeChannel.msg.tt = FIN and
	  p.writeChannel.msg.tt.sender.tt = p and
	  p.state.tt = LastAckState and
	  thisChannelNoChange[t, tt, p.readChannel]))
}

pred HandleFinWait2(t, tt: Time, p: Process) {
	p.state.t = FinW2State
	((p.readChannel.msg.t = FIN and
	  p.read.tt = FIN and
	  p.read.tt.sender.tt = FIN.sender.t and
	  thisChannelNoChange[t, tt, p.readChannel] and
	  p.state.tt = TimeWaitState and
	  p.writeChannel.msg.tt.sender.tt = p and
	  p.writeChannel.msg.tt = ACK))
}

pred HandleClosing(t, tt: Time, p: Process) {
	p.state.t = ClosingState
	noChannelChange[t, tt]
	((p.readChannel.msg.t = ACK and
	  p.read.tt = ACK and
	  p.read.tt.sender.tt = ACK.sender.t and
	  p.state.tt = TimeWaitState))
}

pred HandleLastAck(t, tt: Time, p: Process) {
	p.state.t = LastAckState
	noChannelChange[t, tt]
	((p.readChannel.msg.t = ACK and
	  p.read.tt = ACK and
	  p.read.tt.sender.tt = ACK.sender.t and
	  p.state.tt = ClosedState))
}

pred HandleTimeWait(t, tt: Time, p: Process) {
	p.state.t = TimeWaitState
	p.state.tt = ClosedState
	noChannelChange[t, tt]
}

pred HandleEndState(t, tt: Time, p: Process) {
	p.state.t = EndState
	noChannelChange[t, tt]
}

pred AttackerModel(t, tt: Time) {
	noProcChange[t,tt,TCP_A] and
	noProcChange[t,tt,TCP_B] and
	one c: Channel, m: Message | c.msg.tt = m and
					         c.msg.tt.sender.tt = Attacker and
					         m != INIT and
					         thisChannelNoChange[t, tt, Channel - c]
}

pred init (t: Time) {
	TCP_A.state.t = ClosedState and
	TCP_B.state.t = ClosedState and
	TCP_A.readChannel = BtoA and
	TCP_A.writeChannel = AtoB and
	TCP_B.readChannel= AtoB and
	TCP_B.writeChannel = BtoA and
	AtoB.msg.t = INIT and
	BtoA.msg.t = INIT and
	no AtoB.msg.t.sender.t and
	no BtoA.msg.t.sender.t and
	no TCP_A.read.t and
	no TCP_B.read.t
}

fact Traces {
	init[first] and
	all t: Time - last | let tt = t.next |
	(AttackerModel[t, tt]) iff not
	(one p: Participant |
		noProcChange[t, tt, Participant - p] and
	(HandleClosed[t, tt, p]
	 iff not HandleListen[t, tt, p]
	 iff not HandleSynSent[t, tt, p]
	 iff not HandleSynRec[t, tt, p]
	 iff not HandleEstablished[t, tt, p]
	 iff not HandleFinWait1[t, tt, p]
	 iff not HandleClosedWait[t, tt, p]
	 iff not HandleFinWait2[t, tt, p]
	 iff not HandleClosing[t, tt, p]
	 iff not HandleLastAck[t, tt, p]
	 iff not HandleEndState[t, tt, p]))
}

fact {
	all t: Time | Attacker.state.t = AttackerState
}

fact {
	all m: Message, t:Time | !(some c: Channel | c.msg.t = m)  implies no m.sender.t
}

fact {
	all t: Time | TCP_A.state.t != AttackerState and TCP_B.state.t != AttackerState
}

pred thisChannelNoChange(t, tt: Time, c: Channel) {
	c.msg.t = c.msg.tt and
	c.msg.t.sender.t = c.msg.tt.sender.tt
}

pred noChannelChange(t, tt: Time) {
	AtoB.msg.t = AtoB.msg.tt and
	AtoB.msg.t.sender.t = AtoB.msg.tt.sender.tt and
	BtoA.msg.t = BtoA.msg.tt and
	BtoA.msg.t.sender.t = BtoA.msg.tt.sender.tt
}

pred noProcChange(t, tt: Time, p: Participant) {
	p.state.t = p.state.tt and
	p.read.t = p.read.tt
}

pred LeadsTo(s1, s2: ProtocolState) {}

pred NoHalfClosedConnectionEst {
	all t: Time |
		(TCP_A.state.t = ClosedState) implies !(TCP_B.state.t = EstState)
}

run NoHalfClosedConnectionEst for 10

assert CheckNoHalfClosedConnectionEst {
	NoHalfClosedConnectionEst
} check CheckNoHalfClosedConnectionEst for 7

pred PeersDoNotGetStuck {
	!(some t: Time | all tt: t.nexts |
	  TCP_A.state.tt = TCP_A.state.t and
	  TCP_B.state.tt = TCP_B.state.t and
	  TCP_A.state.t != EndState and
	  TCP_B.state.t != EndState)
}

assert CheckPeersDoNotGetStuck {
		PeersDoNotGetStuck
} check CheckPeersDoNotGetStuck for 10

pred test { some t: Time | TCP_A.state.t = SynSentState}
run test for 10

pred relEqualsMessage(x, y: Message) {
	x = y
}

pred relAInState(s: ProtocolState, t:Time) {
	TCP_A.state.t = s
}

pred relBInState(s: ProtocolState, t:Time) {
	TCP_B.state.t = s
}

pred relEqualsProcess(x, y: Participant) {
	x = y
}

pred msgSameSender(m, mm: Message, t: Time) {
	m.sender.t = mm.sender.t
}

pred attackerSentMsg(m: Message, t: Time) {
	m.sender.t = Attacker
}

pred relNotEqualsTime(x: Time, y: Time) {
	!(x = y)
}

pred relHappensBefore (t: Time, tt: Time) {
	t.lt[tt]
}

pred msgInAChannel(m: Message, t: Time) {
	AtoB.msg.t = m
}

pred msgInBChannel(m: Message, t: Time) {
	BtoA.msg.t = m
}

pred AReadAttacker(t: Time) {
	TCP_A.read.t.sender.t = Attacker
}

pred BReadAttacker(t: Time) {
	TCP_B.read.t.sender.t = Attacker
}

pred attackerSentSyn(t: Time) {
	SYN.sender.t = Attacker
}

pred attackerSentSynAck(t: Time) {
	SYN_ACK.sender.t = Attacker
}
