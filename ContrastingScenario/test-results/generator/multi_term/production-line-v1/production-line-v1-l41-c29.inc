open util/ordering[Position]

// Consider the following model of an automated production line
// The production line consists of several positions in sequence
sig Position {}

// Products are either components assembled in the production line or 
// other resources (e.g. pre-assembled products or base materials)
sig Product {}

// Components are assembled in a given position from other parts
sig Component extends Product {
    parts : set Product,
    position : one Position
}
sig Resource extends Product {}

// Robots work somewhere in the production line
sig Robot {
        position : one Position
}


// A component requires at least one part
pred Inv1o {
    all c : Component | some c.parts
}

// A component cannot be a part of itself
pred Inv2o {
    all c : Component | c not in c.^parts
}

// The position where a component is assembled must have at least one robot
pred Inv3o {
    all c : Component | some (Robot <: position).(c.position) & Robot
}

// The parts required by a component cannot be assembled in a later position
pred Inv4o {
    all c : Component, p : c.
}