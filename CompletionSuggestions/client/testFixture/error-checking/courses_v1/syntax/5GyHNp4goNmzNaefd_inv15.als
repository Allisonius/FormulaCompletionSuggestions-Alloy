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

pred inv15{
	
  all s1,s2 : Student | all p : Project | p in s1.projects and p in s2.projects implies (s1.projects.grades+1 == s2.projects.grades or s1.projects.grades-1 == s2.projects.grades or s1.projects.grades == s2.projects.grades or s1.projects.grades == s2.projects.grades+1 or s1.projects.grades == s2.projects.grades-1)

}


