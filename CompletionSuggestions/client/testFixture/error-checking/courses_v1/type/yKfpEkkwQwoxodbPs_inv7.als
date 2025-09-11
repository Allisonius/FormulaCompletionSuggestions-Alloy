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

pred inv7{
	
	all p1, p2: Project, s: Student, c: Course | c in s.enrolled and p1 c.projects and p2 in c.projects implies p1 = p2 
}

