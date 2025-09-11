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
	
	all s1, s2: Student | all c : Course | s1!=s2 and working2gether[s1,s2,c] implies s1(c.grades)=prev[s2.(c.grades)]
}


pred working2gether[s1,s2:Student,c:Course]{
	all p : c.projects | c in s1.enrolled+s2.enrolled and p in s1.projects+s2.projects
}

