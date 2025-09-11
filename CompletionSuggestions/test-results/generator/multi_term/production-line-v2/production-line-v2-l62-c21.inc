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

// Workers are either human or robots
pred inv1o {
	Worker = Human + Robot
}

// Every workstation has workers and every worker works in one workstation
pred inv2o {
	workers in Workstation one -> some Worker
}

// Every component is assembled in one workstation
pred inv3o {
	all c : Component | one c.workstation
}

// Components must have parts and materials have no parts
pred inv4o_1 {
	all c : Component | some c.parts
}

pred inv4o_2 {
	all m : Material | no m.parts
}

// Humans and robots cannot work together
pred inv5o {
	all c : Workstation | no (c.workers & Human) or no (c.workers & Robot)
}

// Components cannot be their own parts
pred inv6o {
	no c : Component | c in c.^parts
}

// Components built of dangerous parts are also dangerous
pred inv7o {
	all c : Component | some c.parts & Dangerous implies c in Dangerous
}

// Dangerous components cannot be assembled by humans
pred inv8o {
	all c : Component & 
}

// The workstations form a single line between begin and end
pred inv9o_1 {
	all w : Workstation - end | one w.succ
}

pred inv9o_2 {
	no end.succ
}

pred inv9o_3 {
	Workstation in begin.*succ
}

// The parts of a component must be assembled before it in the production line
pred inv10o {
	all c : Component, p : c.parts | p.workstation in ^succ.(c.workstation)
}