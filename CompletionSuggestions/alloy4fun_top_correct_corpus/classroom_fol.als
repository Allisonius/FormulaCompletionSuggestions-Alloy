 /* The registered persons. */
 sig Person  {
	/* Each person tutors a set of persons. */
	Tutors : set Person,
	/* Each person teaches a set of classes. */
	Teaches : set Class
 }
 
 /* The registered groups. */
 sig Group {}
 
 /* The registered classes. */
 sig Class  {
	/* Each class has a set of persons assigned to a group. */
	Groups : Person -> Group
 }
 
 /* Some persons are teachers. */
 sig Teacher extends Person  {}
 
 /* Some persons are students. */
 sig Student in Person  {}
 
 /* Every person is a student. */
 pred inv1 {
	all p: Person|p in Student
 }
 
 /* There are no teachers. */
 pred inv2 {
	all p:Person | p not in Teacher
 }
 
 /* No person is both a student and a teacher. */
 pred inv3 {
	all p:Person | p in Student implies p not in Teacher
 }
 
 /* No person is neither a student nor a teacher. */ 
 pred inv4 {
	all p:Person | p in Student or p in Teacher
 }

 /* There classes assigned to teachers. */ 
 pred inv5 { //same as oracle
 	some Teacher.Teaches
 }
 
 /* Every teacher has classes assigned. */ 
 pred inv6 {
 	all t:Teacher|some c:Class | t->c in Teaches
 }
 
 /* Every class has teachers assigned. */ 
 pred inv7 { //same as oracle
 	all c:Class | some Teacher&Teaches.c
 }
 
 /* Teachers are assigned at most one class. */
 pred inv8 {
 	all t:Teacher, c1, c2:Class |t->c1 in Teaches and t->c2 in Teaches=>c1=c2
 }
 
 /* No class has more than a teacher assigned. */
 pred inv9 { //same as oracle
 	all c:Class | lone Teacher&Teaches.c
 }
 
 /* For every class, every student has a group assigned. */
 pred inv10 {
 	all c:Class,s:Student|some g:Group| c->s->g in Groups
 }

 /* A class only has groups if it has a teacher assigned. */
 pred inv11 { //same as oracle
 	all c:Class | some c.Groups implies some Teacher&Teaches.c
 }
 
 /* Each teacher is responsible for some groups. */
 pred inv12 { //same as oracle
 	all x:Teacher | some x.Teaches.Groups
 }

 /* Only teachers tutor, and only students are tutored. */
 pred inv13 { //same as oracle
 	Tutors in Teacher -> Student
 }

 /* Every student in a class is at least tutored by the teachers
  * assigned to that class. */
 pred inv14 { //same as oracle
 	all c:Class,p:Person | p in (c.Groups).Group implies Teaches.c -> p in Tutors
 }

 /* Assuming a universe of 3 persons, the tutoring chain of every
  * person eventually reaches a Teacher. */
 pred inv15 { //same as oracle
 	all p:Person | some Teacher&(^Tutors).p
 }