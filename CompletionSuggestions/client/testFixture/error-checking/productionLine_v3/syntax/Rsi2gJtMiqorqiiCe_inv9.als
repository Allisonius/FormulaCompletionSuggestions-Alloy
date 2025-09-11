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

(all w1:Workstation, w2:Workstation | (w1 in begin and w1!=w2) implies w1 in w2.succ)
and
(all w: Workstation | w not in w.succ)
and
(all w:Worktation | w not in end implies one w.succ)
}

