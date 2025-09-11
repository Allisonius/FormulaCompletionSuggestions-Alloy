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

one Workstation & begin
one Workstation & end
no begin in Workstation.^succ
no end in ^succ.Workstation
all w : Workstation | one w & (^succ.Workstation + Workstation.^succ)
}

