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
	
     
      
    
  
    
    all p : Project , g,g1 : (Person :> projects.p).(projects.p).grades) | g = g1 or g1=prev[g] or g=prev[g1] 
  
}


