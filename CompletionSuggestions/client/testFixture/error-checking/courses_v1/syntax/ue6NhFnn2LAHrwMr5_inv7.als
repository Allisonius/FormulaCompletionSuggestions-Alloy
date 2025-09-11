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
	
  	some p1, p2: Project, 
         c1,c2: Course| 
    all s: Student| (p1+p2) in s.projects and 
  					p1 in c1.projects and p2 in c2.projects
  					implies c1 != c2
  
  
  s.projects in s.enrolled.projects 
}

