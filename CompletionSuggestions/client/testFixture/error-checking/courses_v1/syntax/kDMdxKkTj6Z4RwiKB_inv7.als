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
	
  	
  	all s: Student | ((all c : Course, p1 : Project, p2 : Project | s -> p1 in projects and c -> p1 in projects 
  		and s -> p2 in projects and c -> p2 in projects) => (p2 = p1)) 
  
}

