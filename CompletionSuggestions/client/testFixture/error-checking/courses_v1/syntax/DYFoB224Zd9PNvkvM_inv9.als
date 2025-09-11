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
	
	all t1,t2:Person | t1 != t2 and some t1.enrolled & t2.enrolled => 
  		not some t1.enrolled & t2.teaches
  
  all p : Person | no (p.teaches.~teaches - p) & p.teaches.~enrolled
}

check {
  }
  	all t1,t2:Person | t1 != t2 and some t1.enrolled & t2.enrolled => 
  		not some t1.enrolled & t2.teaches
  
  }
  implies {
  all p : Person | no (p.teaches.~teaches - p) & p.teaches.~enrolled
  
}  }

