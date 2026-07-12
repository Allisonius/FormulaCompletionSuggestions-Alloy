open util/ordering[Lib] as LibOrd

//////////////////////////////
//////-Declaration////////////
//////////////////////////////
one sig Constants
{
 maxNbLoans : Int
}
fact Constants_facts {
 all x : Constants | x.maxNbLoans = 7
}
sig Book{}
sig Member{}

sig Lib
{
 members:set Member,
 books: set Book ,
 loan: (books -> 
 membersReservingOneBook: (seq members)->books,
 Renew: (books -> members)
}
