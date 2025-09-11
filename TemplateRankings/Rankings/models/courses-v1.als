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
pred inv1o {
	enrolled in Student -> Course
}

// Only professors can teach courses
pred inv2o {
	teaches in Professor -> Course
}

// Courses must have teachers
pred inv3o {
	teaches in Person some -> Course
}

// Projects are proposed by one course
pred inv4o {
	all p : Project | one (Course <: projects).p
}

// Only students work on projects and 
// projects must have someone working on them
pred inv5o {
	all p : Project | some (Person <: projects).p
	all p : Project | (Person <: projects).p in Student
}

// Students only work on projects of courses they are enrolled in
pred inv6o {
	all p : Person | p.projects in p.enrolled.projects
}

// Students work on at most one project per course
pred inv7o {
	all p : Person, c : Course | lone p.projects & c.projects
}

// A professor cannot teach herself
pred inv8o {
	all p : Person | no p.teaches & p.enrolled
}

// A professor cannot teach colleagues
pred inv9o {
	all p : Person | no (p.teaches.~teaches - p) & p.teaches.~enrolled
}

// Only students have grades
pred inv10o {
	Course.grades.Grade in Student
}

// Students only have grades in courses they are enrolled
pred inv11o {
	all c : Course | c.grades.Grade in enrolled.c
}

// Students have at most one grade per course
pred inv12o {
	all p : Person, c : Course | lone p.(c.grades)
}

// A student with the highest mark in a course must have worked on a project on that course
pred inv13o {
	all c : Course, p : Person | last in p.(c.grades) implies some p.projects & c.projects
}

// A student cannot work with the same student in different projects
pred inv14o {
	all p : Person, disj x,y : p.projects | no ((Person <: projects).x & (Course <:projects).y) - p
}

// Students working on the same project in a course cannot have marks differing by more than one unit
pred inv15o {
	all c : Course, p : c.projects, disj x,y : (Person <: projects).p | some c.grades[x] and some c.grades[y] implies c.grades[x] in c.grades[y].(prev+iden+next)
}