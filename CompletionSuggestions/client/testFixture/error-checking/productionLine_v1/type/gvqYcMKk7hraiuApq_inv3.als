open util/ordering[Position]

sig Position {}

sig Product {}

sig Component extends Product {
    parts : set Product,
    position : one Position
}
sig Resource extends Product {}

sig Robot {
        position : one Position
}
pred inv3{
	all c:Component, p:Position | some r : Robot | p in c.position implies some p in r.position 
}


