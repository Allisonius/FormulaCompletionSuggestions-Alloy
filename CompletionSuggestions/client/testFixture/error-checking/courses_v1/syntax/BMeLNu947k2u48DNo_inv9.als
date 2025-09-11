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
	
  all t1, t2, c1,c2: Course | (t1!=t2 and t1 in teaches.c1 and t2 in teaches.c1) implies t1 in teaches.c2 implies t2 not in enrolled.c2 
  (p1!=p2 and p1->c1 in teaches and p2->c1 in teaches) implies 
       (all c2 : Course | p1->c2 in teaches implies p2->c2 not in enrolled)

}

