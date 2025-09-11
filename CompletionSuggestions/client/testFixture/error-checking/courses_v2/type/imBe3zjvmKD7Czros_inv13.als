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
	
    all x:Student, c:Course | some x1:Student | x1.(c.grades) > x.(c.grades) implies some (x1.projects & c.projects)
	
}

