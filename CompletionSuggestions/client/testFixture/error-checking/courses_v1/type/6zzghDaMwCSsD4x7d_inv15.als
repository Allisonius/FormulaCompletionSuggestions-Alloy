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
	
  all disj s1,s2:Student, c:Course, p:Project | 
  		p in s1.projects and p in s2.projects
  		implies
  		s1.(c.grades)

}


