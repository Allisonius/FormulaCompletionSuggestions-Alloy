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

pred inv6{
	
  	all person : Student | all projects : Project | all course : Course | (projects in person.projects and projects in course.projects) implies course in person.enrolled

}

