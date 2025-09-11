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

pred inv9{
	
    all p: Professor | all c: Course | c in p.enrolled implies ((c.grades.Grade) not in (p.teaches.grades.Grade) and p.enrolled not in c.grade.Grade.teaches)
  	
	  
}

