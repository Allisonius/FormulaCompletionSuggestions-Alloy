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
	
  
  all s:Person, c:Course| one p:Project| s in Student and s->c in enrolled and c->p in projects and lone s->p in projects

}

