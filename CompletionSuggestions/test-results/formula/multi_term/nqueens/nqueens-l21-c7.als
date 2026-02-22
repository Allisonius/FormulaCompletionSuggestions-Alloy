module nqueens

sig Queen {
  row : Int,
  col: Int
} 

fact {
  all q: Queen | q.row >= 0 && q.row < #Queen
}

fact {
  all q: Queen | q.col >= 0 && q.col < #Queen
}

pred notSameRow(q1, q2: Queen) {
    q1.row != q2.row
}

pred notSameCol(q1, q2: Queen) {
    q1.
}

pred notSameDiagonal1(q1, q2: Queen) {
    minus[q1.row, q2.row] != minus[q1.col, q2.col]
}

pred notSameDiagonal2(q1, q2: Queen) {
    minus[q1.row, q2.row] != minus[q2.col, q1.col]
}

pred nothreat(q1, q2: Queen) {
    notSameRow[q1, q2]
    notSameCol[q1, q2]
    notSameDiagonal1[q1, q2]
    notSameDiagonal2[q1, q2]
}

pred valid {
  all q1,q2 : Queen | q1 != q2 => nothreat[q1, q2]
}

run valid for exactly 4 Queen