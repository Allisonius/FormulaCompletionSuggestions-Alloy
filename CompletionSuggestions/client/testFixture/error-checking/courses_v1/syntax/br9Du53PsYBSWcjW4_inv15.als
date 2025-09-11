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
	
  	all s1,s2 : Student | all g1,g2 : Grade | all p : Project | all c : Course | s1!=s2 and p in s1.projects&s2.projects and (s1->g1 + s2->g2) in c.grades implies g1=prev[g2] or g2=prev[g1] or g1=G2
}


