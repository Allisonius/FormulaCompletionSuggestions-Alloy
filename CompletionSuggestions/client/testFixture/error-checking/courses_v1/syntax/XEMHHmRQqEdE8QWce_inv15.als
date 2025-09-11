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
	




  all c:Course,p:Project,disj s1,s2:Person | c->p in projects and s1->p in projects and s2->p in projects and (some g:Grade | c->s2->g in grades) implies all g:Grade | c->s1->g in grades implies c->s2->g in .grades.(iden+next+prev)  


}


