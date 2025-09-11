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

pred inv7{
	
  all x : Person | all y : Project | all z : Course | y in z.projects implies y in #(x.projects) = 0 or #(x.projects) = 1
}

