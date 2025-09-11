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
	
    all c1 : Course, c2 : Course, p1 : Professor, p2 : Professor | p1->c1 in teaches implies (p2->c2 in enrolled and c2 != c1)

