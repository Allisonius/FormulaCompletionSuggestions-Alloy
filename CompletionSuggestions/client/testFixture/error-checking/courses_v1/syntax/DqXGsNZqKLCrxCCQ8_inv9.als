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
	
  	
	
  	all p1, p2 : Professor | all c:Course | (c in p1.teaches) and (c in p2.teaches) implies p1 not in enrolled.(p2.teaches)
  	all p1,p2:Professor | all c:Course | c in (p1 + p2).teaches imples p1 not in enrolles.(p2.teaches)
}

