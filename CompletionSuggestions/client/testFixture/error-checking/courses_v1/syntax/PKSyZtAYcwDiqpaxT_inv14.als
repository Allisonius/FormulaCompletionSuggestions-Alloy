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
	
  all s,s1: Student, p,p1: Project | p!=p1 ans s!=s1 and s->p in projects and s1->p in projects and s->p1 in projects implies s1->p1 not in projects

}

