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

pred inv15{
	
  	all disj s1,s2 : Student, p : Project | s1+s2 in projects.p and s2.((projects.p).grades)+s1.((projects.p).grades) in 		Student.((projects.p).grades) 	
	implies 
  	next[s1.((projects.p).grades)] = s2.((projects.p).grades) or 
  	prev[s1.((projects.p).grades)] = s2.((projects.p).grades) or 
  	

}


