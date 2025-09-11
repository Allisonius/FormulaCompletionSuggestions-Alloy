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
	all c:Component, p:Position | some r:Robot | c.p in position implies r.p in Position  
}


