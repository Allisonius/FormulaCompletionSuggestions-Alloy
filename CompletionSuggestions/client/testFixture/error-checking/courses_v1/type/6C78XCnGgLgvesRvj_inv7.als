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
	
	all stud:Student, c:Course | stud->c in enrolled implies ((all proj:Project | not stud->c in projects) or (one proj:Project | stud->c in projects))
}

