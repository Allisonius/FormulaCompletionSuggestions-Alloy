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

pred inv1{
	
  	
  	all a : Person, b : Course | a in b.^(grades.~Person) implies a in Student
  
  	a in a.^(parent.~hash)
}

