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
	
  	
  	all s:Student | (some c:Course | c in s.enrolled) implies lone s.projects
	all s:Student | all c:Course | lone (projects.s + projects.c)

}

