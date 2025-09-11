one sig BinaryTree {
  root: lone Node
}

sig Node {
  left, right: lone Node,
  elem: Int
}

fact Reachable {
  Node = BinaryTree.root.*(left + right)
}

fact Acyclic {
  all n : Node {
    n !in n.^(left + right)

    n != BinaryTree.root => 
      lone n2 : Node | n in (n2.left + n2.right)

    some n.(left + right) => n.left != n.right
  }
}


pred Sorted() {
  all n: Node {


    all e : n.right.*(left + right).elem | e > n.elem

  }
}

pred HasAtMostOneChild(n: Node) {
  lone n.(left + right)
}

fun Depth(n: Node): one Int {
  #n.~*(left + right)
}

pred Balanced() {
  all n1, n2: Node {
    (HasAtMostOneChild[n1] and HasAtMostOneChild[n2]) => 
       (minus[Depth[n1],Depth[n2]] >= -1 and minus[Depth[n1],Depth[n2]] <= 1)
  }
}

pred RepOk() {
  Sorted
  Balanced
  some n : Node | Depth[n] > 0
}

run RepOk for 6