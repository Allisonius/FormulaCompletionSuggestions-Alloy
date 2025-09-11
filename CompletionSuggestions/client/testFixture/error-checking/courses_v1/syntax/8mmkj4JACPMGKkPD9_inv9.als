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
	
  	
  	all p1,p2 : Professor | all c1:Course |
      (c1 in p1.teaches and p2->c1 in teaches) implies 
       (all c2 : Course | p1->c2 in teaches implies p2->c2 not in enrolled)

	all p1,p2:Professor,c1:Course | 
  	
  	
}

