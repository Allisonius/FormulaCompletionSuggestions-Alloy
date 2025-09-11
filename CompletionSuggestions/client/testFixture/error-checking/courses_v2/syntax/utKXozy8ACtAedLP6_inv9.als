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
	
  all p1:Professor | all p2:Professor - p | some (p1.teaches and p2.teaches) implies no (p1.enrolled and no p2.enrolled)

}

