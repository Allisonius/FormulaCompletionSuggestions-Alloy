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

pred inv5{
	
	
  	all p : Project, b : Person | p in b.projects => b in Student p in b.projects
  	all p : Project | some b : Person | p in b.projects
}

