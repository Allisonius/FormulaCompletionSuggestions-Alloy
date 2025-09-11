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

begin not in Workstation.succ
all ws : Workstation-begin | in begin.^succ
all ws : Workstation | ws not in ws.^succ
all ws : Workstation-end | end in ws.^succ
}

