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

pred inv6{
	
  	
  	

	all s:Student, c:Course | c in s.enrolled implies (some p:Proejct | p in s.projects and p in c.projects)
}

