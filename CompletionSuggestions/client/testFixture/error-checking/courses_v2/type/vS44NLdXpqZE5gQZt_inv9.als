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
	
	all p1 : Professor |
  		all p2 : Person |
  			(some p2.enrolled & p1.enrolled) implies (no p1.teaches in p2.enrolled)
}

