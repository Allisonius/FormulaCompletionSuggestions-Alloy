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
	
  	all p1,p2 : Person | some c1,c2 : Project | (c1 in p1.project and c1 in p2.projects and c2 in p1.project) implies (c2 in p2.project=

}

