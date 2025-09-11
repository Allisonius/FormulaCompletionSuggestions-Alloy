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
	
  
  all c : Course, s : c.grades.Grade | (all e : grades.Grade.e | ordering/gte[c.grades.s,c.grades.e]) implies c in (Course <: projects).(s.projects)

}

