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

pred inv15{
	
  	all c: Course, p1,p2: Student, g1,g2: Grade | p1->g1 in c.grades and p2->g2 in c.grades and p1 in c.projects.Student and p2 in c.projects.Student and g1 < g2 + 1 and g1 > g2 - 1
  

}


