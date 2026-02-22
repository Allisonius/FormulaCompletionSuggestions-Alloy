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

sig Component extends 
	workstation : set Workstation
}

sig Dangerous in Product {}