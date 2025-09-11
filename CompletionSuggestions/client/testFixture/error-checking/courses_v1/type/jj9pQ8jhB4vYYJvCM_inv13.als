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
	
	all s:Student, c:Course, p: Project | s in c.grades.Grade.last and p in c.projects and c in s.enrolled implies p in s.projects 
}

