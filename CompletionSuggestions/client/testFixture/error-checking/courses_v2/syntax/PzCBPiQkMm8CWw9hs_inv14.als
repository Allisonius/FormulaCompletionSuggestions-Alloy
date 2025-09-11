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
	
  all s:Student, s2:Student, proj1:Project, proj2:Project | proj1 in s.projects and proj1 in s2.projects and s!=s2 implies ( proj2 not in s1.projects) or (proj2 not in s2.projects)
}

