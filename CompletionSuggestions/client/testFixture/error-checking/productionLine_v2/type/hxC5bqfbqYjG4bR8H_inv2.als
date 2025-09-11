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
pred inv2{

all w1,w2 : Worker | all ws1,ws2: Workstation | ws1!=ws2 and w1 in ws1.workers and w2 in ws2.workers implies w1!=w2
all ws : Workstation | some Worker in ws.workers
all w : Worker | w in Workstation.workers
}

