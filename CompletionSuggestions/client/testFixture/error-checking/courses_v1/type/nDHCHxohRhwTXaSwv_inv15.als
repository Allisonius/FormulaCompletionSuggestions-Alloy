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

pred inv15{
	
  	all p : Project | let gs = (projects.p).grades[projects.p] | gs in (first[gs] + prev[first[gs]] + next[first[gs]])
}


