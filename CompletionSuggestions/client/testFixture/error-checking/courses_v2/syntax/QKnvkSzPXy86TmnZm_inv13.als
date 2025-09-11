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
	
	all x,w : Student | all g1,g2:Grade| all z: Course | one q : Project |(z in x.enrolled and z in w.enrolled and x->g1 in z.grades and w->g2 in z.grades and (univ g1)>(univ g2) and g1!=g2 and w!=x) implies (q in z.projects and q in x.projects)
}

