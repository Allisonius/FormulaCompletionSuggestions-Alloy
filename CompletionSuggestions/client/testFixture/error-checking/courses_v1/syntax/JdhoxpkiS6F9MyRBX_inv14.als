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

pred inv14{
	
	
  	
  	
  	all s:Student | all p:Project | s->p in enrolled implies all ss:Student | lone ps:Project | ps in s.enrolled and ps in s2.enrolled
}

