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
	
	all s1,s2: Student | all p1,p2: Project |
  	s1->p1 in projects and s2->p1 in projects and s1!=s2 and p1!=p2 => s1+s2 not in projects.p
  	
}

