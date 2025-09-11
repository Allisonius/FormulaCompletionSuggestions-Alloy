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
	
  all s1 : Person | all ps1,ps2 : project | ps1 in s1.projects and ps2 in s1.projects implies ps1 = ps2

}

