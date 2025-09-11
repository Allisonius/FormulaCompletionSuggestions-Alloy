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

pred inv4{ 
  all p : Project
  all x,y : Course | (#(x.projects)>0 and x!=y) implies #(y.projects)=0
	

}

