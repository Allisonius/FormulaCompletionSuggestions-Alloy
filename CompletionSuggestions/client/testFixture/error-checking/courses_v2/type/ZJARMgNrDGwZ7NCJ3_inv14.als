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
	
  all s1:Student, s2:Student, c1:Course, c2:Course | c1 in s1.projects and c1 in s2.projects implies ((c2 in s1.projects and c2 not in s2.projects) or (c2 not in s1.projects and c2 in s2.projects))
 
}

