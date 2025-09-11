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
	
	all p : Project | all s1, s2 : Student | s1->p in projects and s2->p in projects and s1 != s2 => 
  	( all g1, g2: Grade, c : Course | c->s1->g1 in Grade and c->s2->g2 in Grade => (g1 = g2 or g1 = prev[g2] or g2 = prev[g1]) )
}


