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
	
  all x,y : Professor | all z : Course | (x in teaches.z and y in teaches.z) implies 
  ( 
  	none k : Course | 
    	(x in teaches.k and y in enrolled.k) and (y in teaches.k and x in enrolled.k)
  )

}

