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
	
	all p1,p2 : Professor | all c1,c2 : Course | colleagues[p1,p2] implies c2 not in p2.enrolled
}

pred colleagues[p1, p2 : Professor]{
	p1!=p2 and c1 in p1.teaches&p2.teaches and c2 in p1.teaches 
}

