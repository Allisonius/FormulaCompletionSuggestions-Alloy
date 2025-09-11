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

all ws: Workstation | w not in w.^(succ)
all ws: Workstation | w not in end implies one ws.succ
all ws1,ws2: Workstation | ws2 in begin and ws1 != ws2 implies ws1 in ws2.^(succ)

}

