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
	
	all disj g1,g2 : c.grades, c : Course | one (s1.projects & s2.projects & c.projects) implies  
  	s1.(c.grades) in s2.(c.grades) + prev[s2.(c.grades)] + next[s2.(c.grades)] 
}


