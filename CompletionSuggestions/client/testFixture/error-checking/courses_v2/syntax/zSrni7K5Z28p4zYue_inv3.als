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

pred inv3{
	
  
  all x:Course| some  z:Student-y , y:Professor-z | z->x in enrolled implies y->x in teaches and z!=y

}

