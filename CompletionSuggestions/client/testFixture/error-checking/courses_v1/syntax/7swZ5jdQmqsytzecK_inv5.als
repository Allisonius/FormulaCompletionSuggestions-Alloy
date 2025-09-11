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
	
	
  	(all p:Person, pj:Project | p -> pj in projects imples p in Student) and (all pj:Project | some per:Person | per -> proj in projects)

}

