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
	




  all c:Course,p:Project,disj s1,s2:Person | c->p in Course<:projects and s1->c in Person<:projects and s2->c in Person<:projects and some s2.(c.grades) implies s1.(c.grades) in s2.(c.grades).(iden+next+prev)


}


