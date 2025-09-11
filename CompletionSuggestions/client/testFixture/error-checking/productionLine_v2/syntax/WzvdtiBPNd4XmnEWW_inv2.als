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
pred inv2{

all ws: Workstation | some w: ws.workers
all w: Worker | one w.workstation
all w: Worker, ws1, ws2: w.workstation | ws1 != ws2 => ws1 not in ws2.^succ and ws2 not in ws1.^succ

}

