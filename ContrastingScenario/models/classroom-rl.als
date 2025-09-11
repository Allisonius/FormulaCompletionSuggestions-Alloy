/* First-order logic revision exercises based on a simple model of a 
 * classroom management system. 
 * 
 * The model has 5 unary predicates (sets), Person, Student, Teacher,
 * Group and Class, Student and Teacher a sub-set of Person. There are 
 * two binary predicates, Tutors a sub-set of Person x Person, and 
 * Teaches a sub-set of Person x Teaches. There is also a ternary 
 * predicate Groups, sub-set of Class x Person x Group.
 *
 * Solve the following exercises using only Alloy's first-order logic:
 *		- terms 't' are variables
 *		- atomic formulas are either term comparisons 't1 = t2' and 't1 != t2' or n-ary predicate tests 't1 -> ... -> tn in P' and 't1 -> ... -> tn not in P'
 *		- formulas are composed by 
 *			- Boolean connectives 'not', 'and', 'or' and 'implies'
 *			- quantifications 'all' and 'some' over unary predicates
 **/
 
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
 sig Teacher in Person  {}
 
 /* Some persons are students. */
 sig Student in Person  {}

 
 /* Every person is a student. */
 pred inv1o {
	Person in Student
 }

 /* There are no teachers. */
 pred inv2o {
	no Teacher
 }
 
 /* No person is both a student and a teacher. */
 pred inv3o {
	no Student & Teacher
 }
 
 pred inv4o {
	Person in Student + Teacher
}
/* No person is neither a student nor a teacher. */ 
 
 pred inv5o {
 	some Teacher.Teaches
 }
 /* There classes assigned to teachers. */ 
 
 pred inv6o {
 	all t:Teacher | some t.Teaches
 }
 /* Every teacher has classes assigned. */ 
 
 pred inv7o {
 	all c:Class | some Teacher&Teaches.c
 }
 /* Every class has teachers assigned. */ 
 
 pred inv8o {
 	all t:Teacher | lone t.Teaches
 }
 /* Teachers are assigned at most one class. */ 
 
 pred inv9o {
 	all c:Class | lone Teacher&Teaches.c
 }
 /* No class has more than a teacher assigned. */ 
 
 pred inv10o {
 	all c:Class,s:Student | some s.(c.Groups)
 }
 /* For every class, every student has a group assigned. */
 pred inv10 {
 }
 //SECRET
 pred inv11o {
 	all c:Class | some c.Groups implies some Teacher&Teaches.c
 }
 /* A class only has groups if it has a teacher assigned. */
 pred inv11 {
 }
 //SECRET
 pred inv12o {
 	all x:Teacher | some x.Teaches.Groups
 }
 /* Each teacher is responsible for some groups. */
 pred inv12 {
 }
 //SECRET
 pred inv13o {
 	Tutors in Teacher -> Student
 }
 /* Only teachers tutor, and only students are tutored. */
 pred inv13 {
 }
 //SECRET
 pred inv14o {
 	all c:Class,p:Person | p in (c.Groups).Group implies Teaches.c -> p in Tutors
 }
 /* Every student in a class is at least tutored by the teachers
  * assigned to that class. */
  pred inv14 {
 }
 //SECRET
 pred inv15o {
 	all p:Person | some Teacher&(^Tutors).p
 }
 /* Assuming a universe of 3 persons, the tutoring chain of every
  * person eventually reaches a Teacher. */
  pred inv15 {
 }
