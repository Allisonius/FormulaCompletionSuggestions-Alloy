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
	
  
  all u:Person, p:Project| u->p in projects and u in Student implies some one c:Course |u->c in enrolled and c->p in projects 

}

