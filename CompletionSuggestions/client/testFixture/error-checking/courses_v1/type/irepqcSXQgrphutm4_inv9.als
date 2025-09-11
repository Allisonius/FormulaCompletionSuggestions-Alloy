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

pred inv9{
	
  
  all p: Person, c,c1:Course, ps:Professor | p->c in teaches and ps->c1 in teaches implies ps->c not in enrolled and p->c not enrolled

}

