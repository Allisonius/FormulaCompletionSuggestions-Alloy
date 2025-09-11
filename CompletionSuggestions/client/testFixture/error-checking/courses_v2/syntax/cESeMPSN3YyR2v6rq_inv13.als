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

pred inv13{
	
  	 all c: Course |
    all s: Student |
      let highestMark = max[Grade](s.^(grades.c)) |
        highestMark in s.grades.c => (s.projects & c) != none

}

