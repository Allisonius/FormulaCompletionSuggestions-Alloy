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
	
  	
  	all disj s1, s2 : Student | some s1.projects & s2.projects implies all p : s1.projects & s2.projects | projects.p.s1 in projects.p.s2 + next[projects.p.s2] + prev[projects.p.s2] 
}


