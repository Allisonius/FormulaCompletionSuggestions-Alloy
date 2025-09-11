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
	
  all c : Course | (some s : c.enrolled & Student | (s.grades.c = max (c.enrolled.grades.c)) => s.projects & c.projects != none)

}

