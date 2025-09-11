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

all w1,w2 : Worker | all ws1,ws2 :  Workstation | (ws1->w1 in workers and ws2->w2 and w2 in Human) implies (w2 in Human)

}

