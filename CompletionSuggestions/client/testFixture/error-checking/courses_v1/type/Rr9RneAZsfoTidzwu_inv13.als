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
	
  
  all c : Course, s : enrolled.c | s in c.grades.Grade and not (some e : enrolled.c | e in c.grades.Grade and gt[c.grades.e,c.grades.s]) implies c in (Course <: projects).(s.projects)

}

