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
	
  
  all p:Student, x:Student-p, y:Project, v:Project-y, c:Course, k:Course-c| c->y in projects and p->y in projects and x->p in projects and p->c in enrolled and x->c in enrolled and k->v in projects and p->k in enrolled and p->v in projects implies x->v not in projects  

}

