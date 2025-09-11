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
	
  all p1 : Professor | all p2 : Professor - p1 | all c : Course | (c in p2.enrolled and c in not p1.teaches)

}

