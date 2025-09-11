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



all w, wb : Workstation | wb in begin and w!=wb implies w in wb.^(succ)
all w : Workstation | w not in w.^succ
all w : Workstation | w not in end implies one we : Workstation | some ws : Worksation| we in w.^succ and we in end and ws in w.succ






}

