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
	
  all c: Course, pj: c.projects, disj s1, s2: p.~(Student<:projects) |
  		(s1.(c.grades)).prev =  (s2.(c.grades)) or
  		(s2.(c.grades)).prev =  (s1.(c.grades))

}


