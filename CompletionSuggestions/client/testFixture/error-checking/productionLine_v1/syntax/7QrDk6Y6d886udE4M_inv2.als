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
pred inv2{
	all c1,c2:Component | c1 not in c1.parts | c1 in c2.parts => c2 not in c1.parts
}


