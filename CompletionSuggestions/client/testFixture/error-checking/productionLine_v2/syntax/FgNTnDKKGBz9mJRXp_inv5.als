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

all ws : Workstation | all w1,w2 : Worker |
(ws->w1 in workers and ws->w2 in workers and w1 in Human)
implies (w2 in Human)

}

fun path [c1 : Component,c2:Component]: {
(all c3 : Component | c1->c3 in parts implies c3->c2 not in parts and path[c3,c2])

}

