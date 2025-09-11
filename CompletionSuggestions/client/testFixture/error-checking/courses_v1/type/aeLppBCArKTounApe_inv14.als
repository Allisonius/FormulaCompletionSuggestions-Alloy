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

pred inv14{
	
  	
  
  
  
  all s : Student, disj p,p1,p2 : s.projects | projects.p1 in projects.p2 implies none projects.p & projcets.p1
}

