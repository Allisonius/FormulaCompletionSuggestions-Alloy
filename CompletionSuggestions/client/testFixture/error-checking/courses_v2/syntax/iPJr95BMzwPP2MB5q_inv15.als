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
	
  	
  	all disj s1,s2:Student ,p:Project, c: Course:>projects.p| ( p in s1.projects and p in s2.projects) implies ( (s2 in c.grades.prevs[s1->Grade&c.grades].first ) or  ( s1 in c.grades.prevs[s2->Grade&c.grades].first )   )  
  
  
  
  

}


