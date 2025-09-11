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
	
	all p1, p2 : Professor, c : Course |  and c in p1.teaches and c in p2.teaches implies (all c2 : Course | c2 in p1.teaches implies p2 not in c2.enrolled )
}

