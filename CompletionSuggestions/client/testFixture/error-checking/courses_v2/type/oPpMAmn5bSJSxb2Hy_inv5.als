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
	
	
	all s: Student, p: Person, pr: Project | p = s && s in pr.~projects
  	all pr: Project, s: Student | some pr.~projects
}

