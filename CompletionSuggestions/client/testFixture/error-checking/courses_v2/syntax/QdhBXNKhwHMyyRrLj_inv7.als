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
	
  	all p : Person, Course : c ,ps1,ps2 : Project | ps1 in p.projects && ps2 in p.projects implies ps1 in c.projects && ps2 in c.projects && ps1 = ps2

}

