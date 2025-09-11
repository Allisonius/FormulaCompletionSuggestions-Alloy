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
	
		all s: Student, p1, p2: Project | one c: Course | s in projects.p1  and s in projects.p2 implies projects.p1 != projects.p2

  

}

