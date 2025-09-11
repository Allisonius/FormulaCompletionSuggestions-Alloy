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

pred inv7{
	
  
  all x:Person,y:Course|one z:Project| x->y in enrolled and x in Student and y-> z in projects and enrolled.y and one project.z

}

