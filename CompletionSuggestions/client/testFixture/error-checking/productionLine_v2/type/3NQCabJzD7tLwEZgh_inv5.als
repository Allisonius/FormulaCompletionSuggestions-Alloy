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

all ws:Workstation | not some w1, w2:Worker | ws->w1 and ws->w2 and w1 in Human and w2 in Robot and w1!=w2
}

