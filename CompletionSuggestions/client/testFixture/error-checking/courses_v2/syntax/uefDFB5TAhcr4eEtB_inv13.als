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
	
	 lone pM : Student | all p : Student - pM  | all c : Course | all g : c.grades |
  		ordering.gt[g.pM, g.p] implies some pM.projects & c.projects  
}

