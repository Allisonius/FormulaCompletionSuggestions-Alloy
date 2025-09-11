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
	
  o projeto que esta a fazer pertence a só um curso que esta enrolled e vice versa 
  one project : Project, couse:Course | project in course.enrolled

}

