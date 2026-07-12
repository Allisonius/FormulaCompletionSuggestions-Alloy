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
 loan: (books -> members),
 membersReservingOneBook: (seq members)->books,
 Renew: (books -> members)
}

/* =================================
   = List of no change predicates =
   = They are used in action to describe which state =
   = variables remain unchanged =
===================================*/

pred NoChangebooks[L,LL:Lib]
{
 L.books =LL.books
}

pred NoChangemembers[L,LL:Lib]
{
 L.members =LL.members
}

pred NoChangeloan[L,LL:Lib]
{
 L.loan=LL.loan
}

pred NoChangeSeqBook[L,LL:Lib]
{
 L.membersReservingOneBook= LL.membersReservingOneBook
}

pred NochangeRenew[L,LL:Lib]
{
 L.Renew = LL.Renew
}

/*////////////////
   Initialisation
//////////////////*/
pred Init [L:Lib]
{
 no L.books
 no L.members
 no L.loan
 no L.membersReservingOneBook
 no L.Renew
}

/*////////- //////////
   Acquire
//////////////////-*/
pred CanBeAcquire[L:Lib,b:Book]
{
 no(b & L.books) // verify that b is not in the Library
}

pred Acquire[b:Book,L,LL:Lib]
{
 ////Preconditon//////-
 CanBeAcquire[L,b]

 ////-Postcondition//////-
 LL.books = L.books + b // add the b in the set of books

 ////NoChanges////-
 NoChangemembers[L,LL]
 NoChangeloan[L,LL]
 NoChangeSeqBook[L,LL]
 NochangeRenew[L,LL]
}

/*////////- //////////
   Join
//////////////////-*/
pred CanJoin[m:Member,L:Lib]
{
 no (m & L.members)// m does not exist in the Library.
}

pred Join[m:Member,L,LL:Lib]{
 ////Precondition////-
 CanJoin[m,L]

 ////-Postcondition//////
 LL.members=L.members +m// add the m in the set of members

 //////Nochanges////-
 NoChangebooks[L,LL]
 NoChangeloan[L,LL]
 NoChangeSeqBook[L,LL]
 NochangeRenew[L,LL]
}

/*////////- //////////
   LEND
//////////////////-*/
pred CanLend[m:Member,b:Book,L:Lib]
{
 (b in L.books) and (m in L.members) // b and m are in the Library
 (#((L.loan).m)<Constants.maxNbLoans) //maxNbLoans is the number maximum of loans authorized
 all mm:Member|no((L.loan).mm & b)// b is not lent
 (no (L.membersReservingOneBook.b))// b not reserved
}

pred Lend[m:Member,b:Book,L,LL:Lib]
{
 ////-Precondition////////////
 CanLend[m,b,L]

 ////Postcondition////////////-
 LL.loan=L.loan + (b->m)

 ////Nochanges////////////
 NoChangebooks[L,LL]
 NoChangemembers[L,LL]
 NoChangeSeqBook[L,LL]
 NochangeRenew[L,LL]
}

/*////////- //////////
   RESERVE
//////////////////-*/
pred CanReserve[m:Member,b:Book,L:Lib]
{
 (b in L.books and m in L.members ) // b and m are in the Library
 one (b & ((L.loan).Member)) or (some (L.membersReservingOneBook.b))// the book is a borrowed
  no (m & b.(L.loan)) // m is not lent
 no (Int.(L.membersReservingOneBook.b) & m) //it can't be reserved more than one Time by the same member
}

pred Reserve[m:Member,b:Book,L,LL:Lib]
{
 //// Precondition////
 CanReserve[m,b,L]

 //////PostCondition////-
 LL.membersReservingOneBook.b = L.membersReservingOneBook.b.add[m]

 ////-Nochanges//////-
 all bb:Book - b|LL.membersReservingOneBook.bb = L.membersReservingOneBook.bb
 NoChangebooks[L,LL]
 NoChangemembers[L,LL]
 NoChangeloan[L,LL]
 NochangeRenew[L,LL]
}

/*////////- //////////
   CANCEL
//////////////////-*/
pred CanCancel[m:Member,b:Book,L:Lib]
{
 (b in L.books and m in L.members ) // // b and m are in the Library
  one (Int->m & (L.membersReservingOneBook.b))// b is reserved by m
}

pred Cancel[m:Member,b:Book,L,LL:Lib]
{
 ////////Preconditon//////////////-
 CanCancel[m,b,L]

 ////////Postconditon////////////
 LL.membersReservingOneBook.b=L.membersReservingOneBook.b.delete[
     L.membersReservingOneBook.b.indsOf[m]]// delete m from the list of reservation of b

 //////Nochanges////////
 all bb:Book - b|LL.membersReservingOneBook.bb = L.membersReservingOneBook.bb
 NoChangebooks[L,LL]
 NoChangemembers[L,LL]
 NoChangeloan[L,LL]
 NochangeRenew[L,LL]
}

/*////////- //////////
   RETURN
//////////////////-*/
pred CanReturn[m:Member,b:Book,L:Lib]
{
 (b in L.books and m in L.members )
 one ((L.loan).m & b) // b is already lent to m
}

pred Return[m:Member,b:Book,L,LL:Lib]
{
 ////Precondition////-
 CanReturn[m,b,L]

 ////PostConditon////////
 LL.loan=L.loan - (b ->m) // delete the b->m from the set of loans
 LL.Renew = L.Renew - (b -> m)// same thing

 ////Nochanges////////
 NoChangebooks[L,LL]
 NoChangemembers[L,LL]
 NoChangeSeqBook[L,LL]


}

/*////////////////////
  TAKE
//////////////////////*/
pred CanTake[m:Member,b:Book,L:Lib]
{
 (b in Lib.books) and (m in L.members)// b and m are in the Library
 (#((L.loan).m)<Constants.maxNbLoans) //maxNbLoans is the number maximum of lend authorized
 (L.membersReservingOneBook.b) = (0 -> m) // m is first in the list of reservation
 no (b.(L.loan)) // the book is not lent
}

pred Take[m:Member,b:Book,L,LL:Lib]
{
 ////-Preconditon//////-
 CanTake[m,b,L]

 ////-PostCondition////-
 LL.loan=L.loan + (b->m)
 LL.membersReservingOneBook.b=LL.membersReservingOneBook.b.delete[0]// delete m from the list of reservations of b

 ////-Nochanges//////-
 all bb:Book - b|LL.membersReservingOneBook.bb = L.membersReservingOneBook.bb
 NoChangebooks[L,LL]
 NoChangemembers[L,LL]
 NochangeRenew[L,LL]
}

/*////////////////-
   LEAVE
//////////////////-*/
pred CanLeave[m:Member,L:Lib]
{
 m in L.members
 no (L.loan.m) // m is not in the lent list
 no( Int.(L.membersReservingOneBook.Book) & m)// m has no reseravation
}

pred Leave[m:Member,L,LL:Lib]
{
 //////Preconditon//////-
 CanLeave[m,L]

 //////Postconditon//////
 LL.members = L.members - m

 ////Nochanges////////-
 NoChangeloan[L,LL]
 NochangeRenew[L,LL]
 NoChangeSeqBook[L,LL]
   NoChangebooks[L,LL]
}

/*////////////////-
   DISCARD
//////////////////-*/
pred CanDiscard[b:Book,L:Lib]
{
 b in L.books
 no (b.(L.loan))
 no ((L.membersReservingOneBook.b) )
}

pred Discard[b:Book,L,LL:Lib]
{
 //////Precondition//////-
 CanDiscard[b,L]

 //////Postconditon////////
 LL.books = L.books - b

 ////-Nochanges//////-
 NoChangeloan[L,LL]
 NoChangeSeqBook[L,LL]
   NoChangemembers[L,LL]
 NochangeRenew[L,LL]
}

/*////////////////////
   RENEW
//////////////////////*/
pred CanRenew[m:Member,b:Book,L:Lib]
{
 one (b.(L.loan) & m) // b is already borrowed by m
 L.membersReservingOneBook.b.isEmpty //b has no reservation
}

pred Renew[m:Member,b:Book,L,LL:Lib]
{
 //////Preconditon//////-
 CanRenew[m,b,L]

 ////-Postcondition////////
 LL.Renew=L.Renew ++ (b->m) // override the old b->m

 //////Nochanges////-
 NoChangebooks[L,LL]
 NoChangemembers[L,LL]
 NoChangeloan[L,LL]
 NoChangeSeqBook[L,LL]
}

/*
Specification of property 14 using traces. A fact is used
to define the states from which the property must be
satisfied (ie, the trace does not start from the initial
state of the library.

*/


pred BuggyLeave[L,LL:Lib]{L=LL}//Just For Test

pred LCR[m:Member,L,LL : Lib] {
 some b:Book |
   Cancel[m,b,L,LL]
   or Return[m,b,L,LL]
 //For test switch Leave and BuggyLeave
   or Leave[m,L,LL]
 //or BuggyLeave[L,LL]
}

pred TransLCR[m:Member]
{
 all l : Lib-LibOrd/last |
   LCR[m,l,l.LibOrd/next]
}

pred OrCanLCR[L:Lib,m:Member]
{
 CanLeave[m,L]
 or some b:Book|CanCancel[m,b,L]
 or some b :Book|CanReturn[m,b,L]
}

////////////// Property 14 as a run //////////////////////////
pred NegProp14 {

Prop14StartLib[LibOrd/first] // start from a valid library state

  some m : LibOrd/first.members |

               TransLCR[m]
           and
             m in LibOrd/last.members
           and
             (
           not OrCanLCR[LibOrd/last,m] // at max : LCR can't be applyed
             )
}

// Property 14 is checked by executing a run using a fact which negates property 14
// m members, b books => at most l loans and b-l membersReservingOneBook
// hence, need l returns + (b-l) cancels + 1 leave =>
// b+1 actions =>
// trace of length b+2
run NegProp14 for 10 but 8 Book, 8 Member
run NegProp14 for 8 but 6 Book, 6 Member
run BuggyLeave for 5
run {} for 3 but 2 Lib

//////////////////// Property 14 using a check //////////////////////////
/*
This states property 14 as an assert and uses a check to verify it.
*/
assert Prop14 {

  all m : LibOrd/first.members |
    (
    Prop14StartLib[LibOrd/first]
  and
    TransLCR[m]
   )
  =>
  (
     (not m in LibOrd/last.members)
   or
     ( // case when the sequence is incomplete
        OrCanLCR[LibOrd/last,m]
     )
  )
}

//check {not NegProp14}for 8 but 6 Book, 6 Member
//check Prop14 for 8 but 6 Book, 6 Member
check Prop14 for 10 but 8 Book, 8 Member

////////////-Define what are the valid first library state of a trace ////////////-
pred Prop14StartLib[L:Lib]
{
 all m: Member| (#((L.loan).m) =< Constants.maxNbLoans)

// The book can not be reserved if it's not loaned or reserved
 all b : Book|
    some (L.membersReservingOneBook.b)
    =>
    ((b in L.loan.Member) or ((#L.membersReservingOneBook.b) > 0))

// the Member can not reserve and lend the same book
 all m : Member,b : Book|
    (m in b.(L.loan) => not (m in Int.(L.membersReservingOneBook.b)))

//the same thing
 all m : Member,b : Book|
    (m in Int.(L.membersReservingOneBook.b)) => not (m in b.(L.loan))

// the member can not Renew a book and he has not lend this book
 all b : Book,m : Member|
    (b in L.Renew.m) =>b in (L.loan.m)//7

// books -> lone members
 all b : Book|
    ((b in L.books) and (b in L.loan.Member)) => one (b ->Member & (L.loan))
 all b : Book|
    ((b in L.books) and (b in L.Renew.
//it defines the valid sequences of reservations for a book.
 all m:Member,b:Book |
  (m in Int.(Lib.membersReservingOneBook.b))
=>
 one (Int->m & (Lib.membersReservingOneBook.b))

}
