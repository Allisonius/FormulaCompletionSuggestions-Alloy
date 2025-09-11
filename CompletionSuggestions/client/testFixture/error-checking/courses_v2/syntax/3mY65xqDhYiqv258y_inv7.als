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

pred inv7{
	
	all s : Student |
  		all c1, c2 : s.courses |
  			all p : s.projects |
  				(p in c1 and p in c2) mplies c1 = c2
}

