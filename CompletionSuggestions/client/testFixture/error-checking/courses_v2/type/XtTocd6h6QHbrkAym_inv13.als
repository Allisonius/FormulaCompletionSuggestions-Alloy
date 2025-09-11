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

pred inv13{
	
	all p1,p2:Person| all c:(p1.enrolled & p2.enrolled)| all g1,g2:Grade| g1>g2 and p1->g1 in c.grades and p2->g2 in c.grades implies p1.projects in c.projects
}

