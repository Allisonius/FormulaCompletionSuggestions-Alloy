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
	
	
  	(all p:Person, pj:Project | p->pj in projects implies p in Student) and (all pj:Projects | some p:Person | p->pj in projects)

}

