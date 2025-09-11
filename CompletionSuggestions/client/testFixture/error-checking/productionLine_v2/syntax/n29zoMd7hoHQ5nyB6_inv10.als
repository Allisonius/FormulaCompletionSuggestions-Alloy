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
pred inv10{

all c1, c2: Component | all w1, w2: Workstation |
c2 in c1.parts and c1.workstation in w1 and c2.workstation in w2
implies w1 in w2.succs

}


