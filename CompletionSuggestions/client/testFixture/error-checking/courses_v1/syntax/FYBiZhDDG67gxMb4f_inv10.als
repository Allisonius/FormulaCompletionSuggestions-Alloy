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

pred inv10{
  grades : Person -> Grade
	
  	all p,c,g : univ | p in Person and c in Course and g in Grade and c->p->g in grades implies p in Student

}

