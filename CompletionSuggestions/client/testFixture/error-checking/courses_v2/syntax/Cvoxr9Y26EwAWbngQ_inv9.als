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
	
	all p1:Professor, p2:Professor, c:Course | (c in p1.teaches) and (c not in p2.enrolled) implies (all c2: Course | c2 in p2.teaches and c2. not in p1.enrolled)
}

