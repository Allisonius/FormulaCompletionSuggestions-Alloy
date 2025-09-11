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
	
	all disj s1, s2 : Student |
  		all g1 : s1.(Course.grades) |
  			all g2 : s2.(Course.grades) |
  				some (s1.projects & s2.projects) implies (some (g1.prev).g2 or some (g2.prev).g1)
}


