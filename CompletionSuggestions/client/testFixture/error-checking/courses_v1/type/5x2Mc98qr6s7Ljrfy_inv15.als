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
	
  	all p : Project, s : (Student <: projects.p) | let gs = (projects.p).grades.Student| let g = C.grades[s] | g = gs or g = prev[gs] or prev[g] = gs
}


