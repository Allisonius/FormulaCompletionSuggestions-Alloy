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
	
  	all disj s1,s2:Student ,p:Project| ( p in s1.projects and p in s2.projects) implies all g: (Course:>projects.p).grades | ((s1 in   g ) implies ( s2 in g.prev or s2 in g.next)) and ((s2 in g ) implies ( s1 in g.prev or s1 in g.next) )  
  
  

}


