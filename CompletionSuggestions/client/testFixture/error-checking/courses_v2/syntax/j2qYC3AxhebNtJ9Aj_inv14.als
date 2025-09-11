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
	
  
  all u:Person, k:Person-u, c:Course, x:Project|one p:Projects-x| u->p in projects and k->p in projects implies u->x in projects and k->x not in projects

}

