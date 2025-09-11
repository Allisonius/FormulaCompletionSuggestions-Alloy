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

all ws, wsb : Workstation | (wsb in begin and ws = != wsb) implies ws in wsb.^(succ)
all ws : Workstation | ws not in ws.^(succ)
all ws : Workstaion | ws not in end implies w.succ

}

