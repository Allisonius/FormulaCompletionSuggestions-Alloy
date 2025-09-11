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
	
	all p : Professor |
all c1, c2 : Course |
c1 in p.teaches and c2 in p.enrolled and c1 = c2 => false
  
}

