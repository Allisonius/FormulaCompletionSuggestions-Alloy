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
	
  	all p : Project | some c : Course | c->p in projects and all c1,c2 : Course | c1->p in projects and c2-> in projects implies c1=c2

}

