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
pred inv1{

fact
{
all w: Worker != Human
}

run inv1 {} for 3

}

pred inv1{

fact
{
all w: Worker != Human
}

run inv1 {} for 3

}

