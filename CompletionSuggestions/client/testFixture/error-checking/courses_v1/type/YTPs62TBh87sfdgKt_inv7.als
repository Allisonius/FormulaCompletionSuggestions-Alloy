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
	
	
  	all p1,p2: Project, s: Student, c: Course | (p1 in c.projects) and (p2 in c.projects) and s in p1.projects and p2.projects implies p1=p2
  	
}

