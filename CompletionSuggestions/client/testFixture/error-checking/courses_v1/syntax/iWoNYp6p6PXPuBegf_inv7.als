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
	
  	all  s : Student, c : Course, p : Project | 
    lone p_act : Project | 
    all (p in c.projects) and all (c in s.enrolled) implies p in s.projects
    
}

