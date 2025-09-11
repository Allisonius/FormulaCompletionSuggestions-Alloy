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
	
	
  	all p : Person | all proj : Project | #(p.projects)>0 implies p in Student
  	some p : Person | all c : Course | c.projects in p.project

}

