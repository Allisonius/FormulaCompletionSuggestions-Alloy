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

pred inv15{
	
	all disj s, s1 : Student, p : s.projects & s1.projects | s.((projects.p <: Course).grades) = next[s1.((projects.p <: Course).grades)] or s.((projects.p <: Course).grades) = previous[s1.((projects.p <: Course).grades)] or s.((projects.p <: Course).grades) = s1.((projects.p <: Course).grades)
  	
}


