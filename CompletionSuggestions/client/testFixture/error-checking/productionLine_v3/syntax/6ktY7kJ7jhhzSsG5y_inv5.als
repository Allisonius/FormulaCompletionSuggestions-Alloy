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


all w1,w2 : Worker | all x1: Workstation | (w1 in x1.workers and w2 in x1.workers and w1 != w2) implies (x1!=x2 and x1 in Human and x2 in Human)
}

