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
	
  	all disj p,p1:Professor | p.teaches&p1.teaches>0 implies (#p.enrolled&p1.teaches=0 and  #p1.enrolled&p.teaches=0)

}

