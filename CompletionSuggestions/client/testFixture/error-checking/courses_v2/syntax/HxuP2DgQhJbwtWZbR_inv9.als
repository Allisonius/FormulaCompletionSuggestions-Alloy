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
	

	all p : Professor | all o : Professor - p | some not (col.teaches & p.teaches) or no (col.enrolled & p.teaches))
}

