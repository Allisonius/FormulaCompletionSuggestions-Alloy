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
	
	some p:Person| all p1:Professor  all c1:Course | c1 in p1.teaches and c1 in p.enrolled implies p not in Professor and p1 in Professor   
}

