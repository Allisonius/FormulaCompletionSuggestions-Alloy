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

pred inv5{
	
	
	(all p : Project | all per :Person -Student | no per.projects)
  	and
  	(all p : Projects | some pe: Person | p in pe.projects)
}

