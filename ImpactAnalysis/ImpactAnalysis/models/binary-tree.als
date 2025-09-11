sig Node {
  left: lone Node,
  right: lone Node
}

fact {
  all n : Node | lone n.left && lone n.right
}

pred Acyclic {
  all n : Node {
    n !in n.^(left + right) 
    lone n.~(left + right) 
    no n.left & n.right 
  }
}