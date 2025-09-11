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

pred inv14{
	

  all x:Person, y:Person-x, p:Project, i:Project-p| x-> p in projects and y-> p in projects and x in Student and y in Student implies x-> i in projects a y -> i not in projects
  
}

