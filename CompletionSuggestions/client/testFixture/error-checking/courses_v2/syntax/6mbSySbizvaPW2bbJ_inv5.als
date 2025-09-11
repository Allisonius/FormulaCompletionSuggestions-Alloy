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
	
	
  all ps : Person | ((ps not in Student) implies (no ps.projects))
  all pr : Project, p : Person |and (pr in p.projects))

}

