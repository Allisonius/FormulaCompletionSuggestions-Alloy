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
	
		all s: Student, p1, p2: Project |  s in projects.p1 and s in projects.p2 implies c1 = projects.p1 and  c2 = projects.p2 and c1 != c2

  

}

