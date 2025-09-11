open util/ordering[Grade]

sig Person {
	teaches : set Course ,
	enrolled : set Course ,
	projects : set Project
}

sig Professor , Student in Person {}

sig Course {
	projects : set Project ,
	grades : Person -> Grade
}

sig Project {}

sig Grade {}

// Only students can be enrolled in courses
pred inv1 {
	all p : Person - Student | no p.enrolled
}

// Only professors can teach courses
pred inv2 {
	all p : Person - Professor | no p.teaches
}

// Courses must have teachers
pred inv3 {
	all c : Course | some teaches.c
}

// Projects are proposed by one course
pred inv4 {
	all p : Project | one c : Course | p in c.projects
}

// Only students work on projects and 
// projects must have someone working on them
pred inv5 {
	all p : Person - Student | no p.projects and all p : Project | some s : Student | p in s.projects
}

// Students only work on projects of courses they are enrolled in
pred inv6 { //same as oracle
	all p : Person | p.projects in p.enrolled.projects
}

// Students work on at most one project per course
pred inv7 {
	all p : Person , c : Course , ps1 , ps2 : Project | ps1 in p.projects && ps2 in p.projects && ps1 in c.projects && ps2 in c.projects implies ps1 = ps2
}

// A professor cannot teach herself
pred inv8 {
	all p : Person | all c : Course | c in p.teaches => c not in p.enrolled
}

// A professor cannot teach colleagues
pred inv9 { //same as oracle
	all p : Person | no (p.teaches.~teaches - p) & p.teaches.~enrolled
}

// Only students have grades
pred inv10 {
	all c : Course | all p : Person, g : Grade | p -> g in c.grades => p in Student
}

// Students only have grades in courses they are enrolled
pred inv11 { //same as oracle
	all c : Course | c.grades.Grade in enrolled.c
}

// Students have at most one grade per course
pred inv12 {
	all c : Course | all p : Person | lone g : Grade | p -> g in c.grades
}

// A student with the highest mark in a course must have worked on a project on that course
pred inv13 { //same as oracle
	all c : Course , p : Person | last in p.(c.grades) implies some p.projects & c.projects
}

// A student cannot work with the same student in different projects
pred inv14 { //same as oracle
	all p : Person , disj x , y : p.projects | no ((Person <: projects).x & 
}

// Students working on the same project in a course cannot have marks differing by more than one unit
pred inv15 { //same as oracle
	all c : Course , p : c.projects , disj x , y : (Person <: projects).p | some c.grades[x] and some c.grades[y] implies c.grades[x] in c.grades[y].(prev + iden + next)
}
