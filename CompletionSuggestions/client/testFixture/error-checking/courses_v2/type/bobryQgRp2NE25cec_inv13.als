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

pred inv13{
	
  one x : Student | all y : Student - x | all g,h : Grade | all c:Course | all p: x.projects| x->g in c.grades and y->h in c.grades and g > h implies p in c.projects
}

