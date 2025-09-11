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

all w1, w2: Workstations | (w1 != w2 and w1 in begin) implies w2 in w1.^(succ)
all w: Workstation | w not in w.^(succs)
all w: Workstation | w not in end implies one w.succ

}

