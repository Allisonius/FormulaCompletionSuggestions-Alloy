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
	
  	
  	all s:Student | projects in s some -> Project implies
  	enrolled in Student some -> Course and
    Course <: projects in Course -> Project
}

