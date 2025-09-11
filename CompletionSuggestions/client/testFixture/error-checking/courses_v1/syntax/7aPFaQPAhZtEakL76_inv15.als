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
	
  	all p : Project, all g,h : (projects.p).grades[Student <: projects.p] | g = h or g = prev[h] or prev[g] = h
}


