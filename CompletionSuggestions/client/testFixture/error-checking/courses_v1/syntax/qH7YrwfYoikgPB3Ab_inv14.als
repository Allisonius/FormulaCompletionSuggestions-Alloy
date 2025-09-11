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
	
	all student1, student2 : Student | all project1, project2: Project |((project1 + project2 ) in student1.projects and (project1 + project2 ) in student2.projects and studen1 != student2) implies (project1 = project2)
 }

