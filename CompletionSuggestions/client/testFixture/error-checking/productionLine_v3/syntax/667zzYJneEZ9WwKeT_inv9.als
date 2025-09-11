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

all ws: Workstation |
(ws = begin) => #ws.succ = 1
(ws = end) => #ws.succ = 0
(ws != begin && ws != end) => #ws.succ = 1
all ws1: Workstation, ws2: Workstation |
(ws1.succ[ws2]) => (ws2.succ[ws1] not in ws2.succ)
}

