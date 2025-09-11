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
  (all g1,g2 : Grade | (x->g1 in c.grades and col-> g2 in c.grades) implies g1-g2 < 2 and g1-g2>-2)
  

}


