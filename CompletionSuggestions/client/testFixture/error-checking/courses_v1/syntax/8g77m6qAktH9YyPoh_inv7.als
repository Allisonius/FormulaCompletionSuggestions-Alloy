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

pred inv7{
	
  
  all s:Students | some pr1, pr2: Project| one c: Course | s->pr1 in Person <: projects and s->pr2 in Person <: projects and pr1->c in projects and pr2->c in projects implies pr1 = pr2

}

