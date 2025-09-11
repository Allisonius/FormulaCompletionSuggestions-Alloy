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

pred inv4{
	
  
    all p:Project | one p in Course.projects
  	all p1,p2 : Project , c:Course |p1 in c.projects and p2 in c.projects implies p1 != p2
  
}

