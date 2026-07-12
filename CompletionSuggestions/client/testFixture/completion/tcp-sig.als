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
