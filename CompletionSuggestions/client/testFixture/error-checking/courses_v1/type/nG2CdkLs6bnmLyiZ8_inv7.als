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
    ( some (p in c.projects) and some (c in s.enrolled) ) implies p_act in s.projects
    
}

