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

// Only students can be enrolled in courses
pred inv1 {
	enrolled.Course in Student
}

// Only professors can teach courses
pred inv2 {
	teaches.Course in Professor
}

// Courses must have teachers
pred inv3 {
	all c:Course |some teaches.c
}

// Projects are proposed by one course
pred inv4 {
	all p:Project | one c:Course | p in c.projects
}

// Only students work on projects and 
// projects must have someone working on them
pred inv5 { //same as oracle
	all p : Project | some (Person <: projects).p and all p : Project | (Person <: projects).p in Student
}

// Students only work on projects of courses they are enrolled in
pred inv6 { //same as oracle
	all s1: Person | all p1: Project | s1->p1 in projects implies (some c1: Course | c1->p1 in projects and s1->c1 in enrolled)
}

// Students work on at most one project per course
pred inv7 { //same as oracle
	all p : Person, c : Course | lone p.projects & c.projects
}

// A professor cannot teach herself
pred inv8 { //same as oracle
	(all p : Person | no p.teaches & p.enrolled)
}

// A professor cannot teach colleagues
pred inv9 {
	all p: Person | no ((p.teaches.~teaches)-p) & enrolled.(p.teaches)
}

// Only students have grades
pred inv10 { //same as oracle
	Course.grades.Grade in Student
}

// Students only have grades in courses they are enrolled
pred inv11 {
	all c : Course | c.grades.Grade in c.~enrolled
}

// Students have at most one grade per course
pred inv12 {
	all c : Course | c.grades in Person -> lone Grade
}

// A student with the highest mark in a course must have worked on a project on that course
pred inv13 { //same as oracle
	all c : Course, p : Person | last in p.(c.grades) implies some p.
}

// A student cannot work with the same student in different projects
pred inv14 { //same as oracle
	all p : Person, disj x,y : p.projects | no ((Person <: projects).x & projects.y) - p
}

// Students working on the same project in a course cannot have marks differing by more than one unit
pred inv15 { //same as oracle
	all c : Course, p : c.projects, disj x,y : (Person <: projects).p | some c.grades[x] and some c.grades[y] implies c.grades[x] in c.grades[y].(prev+iden+next)
}
