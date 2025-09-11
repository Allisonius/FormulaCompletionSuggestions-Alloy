sig Workstation {
	workers : set Worker,
	succ : set Workstation
}
one sig begin, end in Workstation {}

sig Worker {}
sig Human, Robot extends Worker {}

abstract sig Product {
	parts : set Product	
}

sig Material extends Product {}

sig Component extends Product {
	workstation : set Workstation
}

sig Dangerous in Product {}
pred inv9{

all ws : Workstation | (ws not in end and ws not in begin) implies one ws.succ
all ws : Workstation | (ws in end ow ws in begin) implies no ws.succ
}

