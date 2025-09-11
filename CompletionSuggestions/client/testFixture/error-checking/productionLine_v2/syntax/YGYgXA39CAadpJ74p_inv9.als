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

all ws1,ws2: Workstation | ws2 in begin and ws1 != ws2 implies ws1 in ws2.^(succ)
all ws: Workstation | ws not in ws.succ
all ws: Workstation | ws not in end implies one w.succ
}

