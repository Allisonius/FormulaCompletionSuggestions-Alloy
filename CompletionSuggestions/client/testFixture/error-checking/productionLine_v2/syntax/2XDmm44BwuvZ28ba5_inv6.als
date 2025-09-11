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
pred inv6{

all c1 : Component | not path[c1,c1]

}

pred path [c1 : Component,c2:Component]{
all c3 : Component | c1->c3 in parts implies (c3->c2 not in parts) and path[c3,c2]

}

