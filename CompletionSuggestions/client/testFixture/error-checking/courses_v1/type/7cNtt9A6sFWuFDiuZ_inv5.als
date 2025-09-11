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
	
	
  all p : Person, c : Course,  pr:Project  | no (p & Student) implies not c in p.projects
  all  pr:Project | some b : Person | pr in b.projects
 }

