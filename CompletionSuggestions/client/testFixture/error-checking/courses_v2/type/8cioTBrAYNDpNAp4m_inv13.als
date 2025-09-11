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

pred inv13{
	
	all c: Course | some p1: Person - Professor | all p2: Person - Professor - p1, g: Grade | some p: Project| p1->g > p2->g implies some(s.projects & c.projects)
}

