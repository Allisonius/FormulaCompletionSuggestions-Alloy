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
	
  	all prof : Professor, coll : Professor-prof, c : Course | (prof.teaches & coll.teaches) implies (implies no (col.enrolled & p.teaches)

}

