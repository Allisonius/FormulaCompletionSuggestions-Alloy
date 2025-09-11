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

pred inv14{
	
	all p: Project |
    all s1, s2: Student | 
      (s1 in p.people) && (s2 in p.people) => (s1 != s2)
}

