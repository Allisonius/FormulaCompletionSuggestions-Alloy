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
pred inv4{
  all disj c1, c2: Component | c1.parts & c2.parts => c1.position = c2.position 
    
}



