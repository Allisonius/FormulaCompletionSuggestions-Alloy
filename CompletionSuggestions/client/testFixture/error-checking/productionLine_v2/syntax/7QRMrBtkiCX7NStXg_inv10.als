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

all w1, w2: Workstation, c1, c2: Components | c2 in c1.^(parts) && w2 in c2.workstation && w1 in c1.workstation => w1 in w2.^(succ)


}


