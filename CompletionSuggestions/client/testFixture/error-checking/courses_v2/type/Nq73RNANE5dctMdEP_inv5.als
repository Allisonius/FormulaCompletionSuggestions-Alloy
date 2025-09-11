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
	
	
  	all p : Person, pr : Project | p not in Student implies no pr in p.projects
  	all pr: Project | some p : Person | p in p.projects

}

