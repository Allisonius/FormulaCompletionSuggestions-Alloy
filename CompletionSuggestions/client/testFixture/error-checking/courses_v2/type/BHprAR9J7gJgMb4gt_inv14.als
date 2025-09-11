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
	
	all s:Student, ss: Student-s,p:projects, pp:projects-p| (p in s.projects && p in pp.projects) => no (pp in s.projects & pp in pp.projects)
}

