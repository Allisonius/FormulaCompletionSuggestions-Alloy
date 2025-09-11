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
	
    all s : Student | all p1, p2 : Project | ((p1 in s.projects) and (p2 in s.projects) and (p1~(Course <: projects))=(p2.~(Course <: projects))) implies (p1=p2)

}

