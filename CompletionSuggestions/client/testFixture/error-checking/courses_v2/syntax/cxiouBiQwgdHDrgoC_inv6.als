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

pred inv6{
	
  all s1 : Person | all ps : Project | ps in s1.project implies (some c1 : Course | ps in c1.projects and c1 in s1.enrolled)

}

