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

all c1, c2: Component | all w1, w2: Workstation | w1 in c1.workstation and w2 in c2.worksation and c2 in c1.^(parts) implies w1 in w2.^(succ)
}


