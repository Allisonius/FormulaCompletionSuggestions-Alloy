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
pred inv5{

all w1,w2 : Worker | all ws : Workstation | (w1->ws in works and w2->ws in works) implies (w1,w2 in Human) or (w1,w2 in Robot)
}

