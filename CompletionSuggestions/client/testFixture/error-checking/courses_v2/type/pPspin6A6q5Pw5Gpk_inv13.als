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
	
    all p1:Student, c:Course | some p2:Student | p2.(c.grades) > p1.(c.grades) implies some (p2.projects & c.projects)
	
}

