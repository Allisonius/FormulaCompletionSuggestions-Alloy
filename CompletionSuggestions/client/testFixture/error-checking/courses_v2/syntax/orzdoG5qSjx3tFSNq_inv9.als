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

pred inv9{
	
  	all x,y:Teacher | all z,w:Course | (z in x.teaches and z in y.teaches and w in x.teaches and z!=w 
  and x!=y) implies w not in y.enrolled
}

