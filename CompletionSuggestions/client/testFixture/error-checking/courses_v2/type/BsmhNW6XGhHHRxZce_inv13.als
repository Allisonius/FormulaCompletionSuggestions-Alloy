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
	
	all disj s1, s2 : Student |
  		all c : s1.enrolled & s2.enrolled |
  			(s1.(c.grades) > s2.(c.grades)) implies some s1.projects & c.projects
}

