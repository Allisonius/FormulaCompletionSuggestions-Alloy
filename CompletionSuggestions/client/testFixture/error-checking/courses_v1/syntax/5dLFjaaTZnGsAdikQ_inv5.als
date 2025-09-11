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

pred inv5{
	
	
  all p:Projects, pe:Person | p in pe.projects implies pe not in Professor
  all p:Projects | some s:Student | p in s.projects

}

