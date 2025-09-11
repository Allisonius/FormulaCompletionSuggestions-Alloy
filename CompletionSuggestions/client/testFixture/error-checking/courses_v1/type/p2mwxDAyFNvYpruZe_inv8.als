open util/ordering[Grade]

sig Person {
	teaches : set Course,
	enrolled : set Course,
	projects : set Project
}

sig Professor,Student in Person {}

sig Course {
	projects : set Project,
	grades : Person -> Grade
}

sig Project {}

sig Grade {}

pred inv8{
	
	all p : Professor | all c: Course | c in p.teaches implies c not in p.enrolled
}

fun colleagues[p : Professor] : set Professor{
	all p : Professor | p implies (Professor-p).teaches = (p.teaches)
}

