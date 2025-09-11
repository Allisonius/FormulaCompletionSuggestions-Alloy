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

all wh : Workstation, w1 : wh.workers, w2 : wh.workrs | (w1 in Human and w2 in Human) or (w1 in Robot and w2 in Robot)

}

