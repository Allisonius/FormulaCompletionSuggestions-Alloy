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
	
    	all p1,p2 : Professor | all c: Course | p1 != p2 and some p1.courses & p2.courses
  		implies no p1.teaches & (enrolled.(p1.enrolled) ).enrolled
  		
      		
       


}

