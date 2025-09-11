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
	
  	all c1 : Course |
  	one s1:Student | c1->s1->g1 in grades and g1=max[]  
  	
  	
	

}

