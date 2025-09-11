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
	
	all p: Person | all project: p.projects | (getProjectStudents[project] & getProjectStudents[p.projects - project])
}

fun getProjectStudents[project : Project]: set Student {
  	(projects.project & Person)
}

