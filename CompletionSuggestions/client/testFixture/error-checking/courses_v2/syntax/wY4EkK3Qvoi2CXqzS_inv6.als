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
	
	all s:Student, p:Project | p in s.projects implies p in c.projects and (some c:Course | p in c.projects and c in s.enrolled)

}

