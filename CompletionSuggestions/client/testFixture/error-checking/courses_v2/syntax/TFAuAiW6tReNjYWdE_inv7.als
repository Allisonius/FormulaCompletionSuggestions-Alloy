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
	
  
  all u:Person,c:Course, p,x:Project| u->c in enrolled and c->p in project and c->x in project and u->x in project and u->p in projects and u in Student implies u=x

}

