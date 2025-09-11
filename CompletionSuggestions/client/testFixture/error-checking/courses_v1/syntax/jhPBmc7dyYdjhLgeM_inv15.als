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
	
  	all t : Tree, n : Name | lone (t.objects & Hash->n)
  
    all h : Hash | lone ( hash.h )
  	
  	all h : Hash - Tree.hash - Blob.hash, t : Tree | no ( h->Name & t.objects ) 
  	all c : Commit, h : Hash - Tree.hash | h not in c.tree
  	all c : Commit, h : Hash - Commit.hash | h not in c.parent
  	
  	all c : Commit | no (c.hash & c.parent)
  	all t : Tree | no (t.hash->Name & t.objects) 

}


