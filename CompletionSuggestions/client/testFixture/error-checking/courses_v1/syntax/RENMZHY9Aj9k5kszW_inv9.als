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
	
	all person1, person2 : Person | all course : Course | (person1 in Professor and course in person2.enrolled and course in person1.teaches) person2 in Student
}

