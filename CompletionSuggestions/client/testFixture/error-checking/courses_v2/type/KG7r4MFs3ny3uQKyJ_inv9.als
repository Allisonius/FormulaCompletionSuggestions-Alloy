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
	
	all x, y : Professor | some z: Course | x in teaches.z and y in teaches.z implies no (x.teaches & enrolled.y and y.teaches and enrolled.x)
}

