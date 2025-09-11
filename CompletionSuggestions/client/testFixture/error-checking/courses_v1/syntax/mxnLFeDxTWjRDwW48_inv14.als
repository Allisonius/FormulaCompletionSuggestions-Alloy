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
	
  all s1, s2 : Student | all p1, p2 : Project | p1 in s1.projects and p2 in s1.projects and p1 in s2..projects and p2 in s2.projects implies p1 = p2
}

