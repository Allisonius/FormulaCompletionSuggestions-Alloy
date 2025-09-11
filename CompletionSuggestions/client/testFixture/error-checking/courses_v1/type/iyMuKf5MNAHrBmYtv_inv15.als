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
	
  	all s1, s2: Student | all p1: Project | all c1: Course |
  		(s1->p1 in projects and s2->p1 in projects and s1!=s2 and c1->p1 in projects) implies
  			all g1, g2: Grade | (c1->s1->g1 in grades and c1->s2->g2) implies 
  				(g1=prev[g2] or g2=prev[g1] or g1=g2)
}


