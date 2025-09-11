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
	
 one pM : Student | all p : Student | all c : Course | all g : c.grades |
          gte[g.pM, g.p] implies some pM.projects & c.projects 
}

