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
	
	
    all p : Project, ps : Person | (p->ps in projects implies p in Student) and ( some ps2 : Person | ps2->p in projects)

}

