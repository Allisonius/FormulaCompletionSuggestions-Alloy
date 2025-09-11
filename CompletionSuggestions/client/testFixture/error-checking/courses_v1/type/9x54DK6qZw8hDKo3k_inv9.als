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

pred inv9{
	
	all t1,t2:Professor, c:Course | c in t1.enrolled and c in t2.enrolled => 
  		no t1->c in teaches and no t2->c in teaches
}

