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

no end.succ+succ.begin
one succ.end
one begin.succ
all w : Workstation | w != begin&suc
all w : Workstation-end-begin | one w.succ && one succ.w && w.succ != succ.w
}

