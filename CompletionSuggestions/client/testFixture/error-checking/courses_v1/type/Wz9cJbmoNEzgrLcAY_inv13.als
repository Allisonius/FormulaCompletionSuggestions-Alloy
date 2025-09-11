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
	
  all c : Course, s : enrolled.c | not (some e : enrolled.c | c.grades.e > s.grades.s) implies c in (Course <: projects).(s.projects)

}

