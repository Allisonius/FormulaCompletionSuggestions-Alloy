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

pred inv12{
  all x:Student|all y:Course|one z:Grade | y in x.enrolled implies (x->z in y.Course or x->z not in y.Course)
	

}

