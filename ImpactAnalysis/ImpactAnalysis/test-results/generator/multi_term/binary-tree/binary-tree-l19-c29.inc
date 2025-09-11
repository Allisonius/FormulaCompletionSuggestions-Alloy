sig Node {
  left: set Node,
  right: set Node
}

fact {
  all n : Node | lone n.left && lone n.right
}

pred Acyclic_1 {
  all n : Node | n !in n.^(left + right)
}

pred Acyclic_2 {
  all n : Node | lone n.~(left + right)
}

pred Acyclic_3 {
  all n : Node | no n.left & 
}