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
	
  
    all p:Project | p in Course.projects
  	all p:Project, c1,c2:Course | p1 in c1.projects and p2 in c2.projects implies c1!=c2
}

