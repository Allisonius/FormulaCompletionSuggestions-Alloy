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
  iden & Component->Robot in (Component:>(position.~position)).~(Component:>(position.~position))
}


