open util/ordering[Lib] as LibOrd

//////////////////////////////
//////-Declaration////////////
//////////////////////////////
one sig Constants
{
 maxNbLoans : Int
}
fact Constants_facts {
 all x : Constants | x.
}
sig Book{}
sig Member{}

sig Lib
{
 members:set Member,
 books: set Book ,
 loan: (books -> members),
 membersReservingOneBook: (seq members)->books,
 Renew: (books -> members)
}
