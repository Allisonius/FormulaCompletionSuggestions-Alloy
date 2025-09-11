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
	
    all p1,p2: Professor| (no p1.enrolled & (p1.teaches & p2.teaches)) and (no p2.enrolled & (p1.teaches & p2.teaches)



}

