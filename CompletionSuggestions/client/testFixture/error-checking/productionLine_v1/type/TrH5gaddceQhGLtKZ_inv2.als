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
	all c,c1 : Component, p : Position | (c not in c->parts) and (c1 not in c1->parts) and c->p + c1->p in position => c = c1 
}


