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
	
  	all disj s1,s2:Student | c1,c2:Course | (s1 in c1.project & s2 in c1.project) implies no (s1 in c2.project && s2 in c2.project)

}

