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
	
  all x: Student | all col : Student - x | all p: x.projects & col.projects | all c: Course | p in c.projects implies 
  (all g1,g2 : Grade | x->g1  and col-> g2 )
  

}


