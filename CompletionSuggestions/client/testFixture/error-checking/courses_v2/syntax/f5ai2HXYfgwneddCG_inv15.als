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
	
  	all s1, s2 : Student, p : Project, g1,g2 : Grade, c : Course | (s1 in projects.p and s2 in projects.p and c->s1->g1 in grades and c->s2->g2 in grades) implies (mod(g1-g2) <=1)

}


