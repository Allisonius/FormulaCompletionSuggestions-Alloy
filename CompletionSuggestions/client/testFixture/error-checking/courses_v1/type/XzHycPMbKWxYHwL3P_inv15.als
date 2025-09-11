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
	
  all c: Course, p: c.projects, disj s1,s2: (Person<:projects).p | (some s1.(c.grades) and some s2.(c.grades)) implies s1.(c.grades) = s2.(c.grades) || s1.(c.grades) in s2.c.grades.(next+prev)

}


