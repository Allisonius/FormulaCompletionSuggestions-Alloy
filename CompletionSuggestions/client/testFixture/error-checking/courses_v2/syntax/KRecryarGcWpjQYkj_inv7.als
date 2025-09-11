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
	
  all c1,c2:Course|all y:Student|all p1,p2:Project | (p1 in y.projects and p2 in y.projets and p1 in c1.projects and p2 in c2.projects and p1!=p2) implies c1!=c2

}

