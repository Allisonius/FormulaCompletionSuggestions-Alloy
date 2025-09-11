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
	
  	all s : Student, c : Course, p : Project , g : Grade| max(c.grades) in c.grades[s] && p in c.projects implies p in s.projects

}

