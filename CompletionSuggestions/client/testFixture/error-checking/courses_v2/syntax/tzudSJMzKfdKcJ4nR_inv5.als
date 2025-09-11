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
	
  all proj:Project, p:Person | (p in projects.proj implies p in Student) and (all proj2:Project, some p2:Person | p2 in projects.proj2)

}

