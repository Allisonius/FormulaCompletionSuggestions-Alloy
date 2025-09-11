sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4 {
x implies (all s:State | some i:Init | s in i.^succ)
}

pred x{
	all s1,s2:State | s1->s2 in succ iff some y:Event | s1->y->s2 in trans
}

/*
The LTS does not contain deadlocks, ie, each state has at least a 
transition.
*/

pred inv4c {
	let ts = {s1,s2:State | some e:Event | s1->e->s2 in trans} | all s:State | some i:Init | s in i.^ts
}

check correct { inv4 <=> inv4c}
pred under { inv4 and !inv4c}
pred over { !inv4 and inv4c}
run over 
run under 

