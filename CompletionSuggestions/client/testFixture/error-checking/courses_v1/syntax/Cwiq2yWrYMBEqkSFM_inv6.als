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

pred inv6{
	
	cursos dos projetos tem de estar nos cursos enrolled
  	all s : Student, c : Course | c in s.projects implies c in s.enrolled 
}

