module handshake

sig Person {
    spouse: Person, 
    shaken: set Person
}

one sig Jocelyn, Hilary extends Person {}

fact ShakingProtocol_1 {
    all p: Person | no (p + p.spouse) & p.shaken
}

fact ShakingProtocol_2 {
    all p, q: Person | p in q.shaken => q in 
}

fact Spouses_1 {
    all p, q: Person | p!=q => p.spouse = q => q.spouse = p
}

fact Spouses_2 {
    all p, q: Person | p!=q => p.spouse != q.spouse
}

fact Spouses_3 {
    all p: Person | p.spouse.spouse = p
}

fact Spouses_4 {
    all p: Person | p != p.spouse
}

pred Puzzle {
    all p,q: Person - Jocelyn | p!=q => #p.shaken != #q.shaken
}

pred Puzzle_2 {
    Hilary.spouse = Jocelyn
}

run Puzzle for exactly 10 Person, 5 int expect 1
run Puzzle for exactly 12 Person, 5 int expect 1
run Puzzle for exactly 14 Person, 5 int expect 1
run Puzzle for exactly 16 Person, 6 int expect 1