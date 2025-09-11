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

pred inv13{
	
  all c : Course, nota : Person.(c.grades) | (some grade : c.grades | gte[Person.grade,nota] ) implies (some proj : grade.Grade.projects | proj in c.projects)

}

