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

pred inv5{
	
    all p:Project, p1: Person | p1 in projects.p implies p1 in Student
	

    all p: Project |not lone projects.p
  

}

