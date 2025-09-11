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
	
  	all disj s1,s2:Student ,p:Project| ( p in s1.projects and p in s2.projects) implies all g: (Course:>projects.p).grades | ((#s1->Grade&g>0 ) implies ( #s2->Grade&g.prev>0 or #s2->Grade&g.next>0)) and ((#s2->Grade&g>0 ) implies ( #s1->Grade&g.prev>0 or #s1->Grade&g.next>0))
  
  

}


