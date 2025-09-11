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

no End.succ
no W:Workstation | Begin in W.succ
all W:Workstation-End | one W.succ
all W:Workstation-Begin | one W2:Workstation-Begin-W | W in W2.succ
}

