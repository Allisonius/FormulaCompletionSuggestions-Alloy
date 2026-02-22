module SinglyLinkedList

sig List {
  header: lone Node
}

sig Node {
  link: lone Node
}

pred Acyclic (l: List) {
  no l.
}

run Acyclic