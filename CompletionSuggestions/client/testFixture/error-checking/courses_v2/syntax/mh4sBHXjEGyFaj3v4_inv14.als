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
	
	all s1, s2 : Student | all p1,p2 : PRoject | p1 in s1.projects and p1 in s2.projects and s1!=s2 and p1!=p2 implies (p2 not in s1.projects) or (p2 not in s2.projects))
}

