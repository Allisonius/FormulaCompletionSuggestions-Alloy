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
	
	
	
  	
  	
  	
  	
  	all x : Professor | no x.projects
  	some y : Project | Student & (projects.y <: Person)
}

