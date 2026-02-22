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
pred inv1 {
	all w:Worker| w in Human or w in Robot
}

// Every workstation has workers and every worker works in one workstation
pred inv2 {
	all w:Workstation | some w.workers
	all w:Worker | one work:Workstation|  w in work.workers
}

// Every component is assembled in one workstation
pred inv3 { //same as oracle
	all c : Component | one c.workstation
}

// Components must have parts and materials have no parts
pred inv4 { //same as oracle
	all c : Component | some c.parts
	all m : Material | no m.parts
}

// Humans and robots cannot work together
pred inv5 {
	all w : Workstation  | no w.workers & Robot or no w.workers & Human
}

// Components cannot be their own parts
pred inv6 {
	all c:Component| c not in c.^parts
}

// Components built of dangerous parts are also dangerous
pred inv7 {
	all c:Component, p:c.parts | p in Dangerous implies c in Dangerous
}

// Dangerous components cannot be assembled by humans
pred inv8 {
	all c: Component & Dangerous| all x: c.workstation| no (x.workers & Human)
}

// The workstations form a single line between begin and end
pred inv9 { //same as oracle
	all w : Workstation - end | one w.succ
	no end.succ
	Workstation in begin.*succ
}

// The parts of a component must be assembled before it in the production line
pred inv10 { //same as oracle
	all c : Component, p : c.parts | p.workstation in 
}