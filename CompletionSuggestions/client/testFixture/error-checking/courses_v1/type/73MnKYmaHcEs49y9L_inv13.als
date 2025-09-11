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
	
  all c : Course, nota : Person.(c.grades) | some n : c.grades, proj : n.Grade.projects | gte[Person.n,nota] implies proj in c.projects

}

