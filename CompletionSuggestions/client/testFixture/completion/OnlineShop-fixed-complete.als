open util/ordering[State]

//Begin Data Def

abstract sig Action {}
one sig ShowCatalog, ShowItem, AddItem, ShowBasket, FinalizeOrder, EnterPayment, EnterDelivery, ConfirmOrder, NoAction extends Action {}

abstract sig Data {}
abstract sig UserId, Name, Surname, BankAccount, Profile, ItemId, Description, ItemName, Text, Session, Payment extends Data {}
one sig NoData extends Data {}

one sig UsrUserId extends UserId {}
one sig UsrSession extends Session {}
one sig UsrName extends Name {}
one sig UsrSurname extends Surname {}
//one sig UsrAddress extends Address {}
one sig UsrItemId extends ItemId {}
one sig UsrBankAccount extends BankAccount {}
one sig UsrDescription extends Description {}
one sig UsrItemName extends ItemName {}
one sig UsrText extends Text {}
one sig UsrProfile extends Profile {}
one sig UserPayment extends Payment {}

abstract sig Catalog extends Data {
	itemId: one ItemId
}

one sig UsrCatalog extends Catalog {}

one sig UserItemId extends ItemId {}

abstract sig User{
	catalog: one Catalog,
	userId: one UserId,	
	profile: one Profile,
	payment: one Payment,
	basket: one ItemId,
	session: one Session,
	initialK: set Data
}

one sig Usr extends User {}

//End Data Def

//---------------------------------------------

//Begin State Def

sig State {
	//User
	user: one User,
	//Controlss Predicates
	action: one Action,
	grant: one Data,
	checked: set Data,
	AJAX: set Data,
	PageIncluded: set Data,
	echo: set Data,
	exec: set Data,
	//Web applicationss Events
	showDB: set Data,
	writeDB: set Data,
	edit: set Data,
	writeSD: set Data,
	showSD: set Data,
	writeFS: set Data,
	showFS: set Data,
	gainK: User -> set Data
}

//End State Def

//-----------------------------------------------------------------
//-----------------------  Begin Transition Def  -----------------------
//-----------------------------------------------------------------

fact UsrCatalog_def {
	UsrCatalog.itemId = UsrItemId
}

fact Usr_def {
	Usr.catalog = UsrCatalog
	Usr.userId = UsrUserId
	Usr.profile = UsrProfile
	Usr.payment = UserPayment
	Usr.basket = UserItemId
	Usr.session = UsrSession
	Usr.initialK = NoData
}

fact{
	//User
	first.user = Usr
	//Controlss Predicates
	first.action = NoAction
	first.grant = UsrSession
	first.checked = NoData
	first.PageIncluded = NoData
	first.echo = NoData
	first.exec = NoData
	//Web applicationss Events
	first.showDB = NoData
	first.writeDB = NoData
	first.edit = NoData
	first.writeSD = NoData
	first.showSD = NoData
	first.writeFS = NoData
	first.showFS = NoData
	first.AJAX = NoData
	(all u:User | first.gainK[u] = NoData)
}

fact {
	all s: State, ss: s.next, x:Action {
		x in s.action implies x not in ss.action	
	}
}

fact {
	all s: State, ss: s.next, x:Action{
	x in s.action implies x not in ss.^next.action}}



fact {
	all s: State, ss: s.next{
		ShowCatalog[s,ss] or ShowItem[s,ss] or AddItem[s,ss] or ShowBasket[s,ss]
		or FinalizeOrder[s,ss] or EnterPayment[s,ss] or 
		EnterDelivery[s,ss] or ConfirmOrder[s,ss]
	}
}
/*
fact {
	all s: State, ss: s.next{
		NoAction in s.action implies ShowCatalog in ss.action}}
*/
fact {
	all s: State, ss: s.next{
		ShowCatalog in s.action implies ShowItem in ss.action}}
fact {
	all s: State, ss: s.next{
		ShowItem in s.action implies AddItem in ss.action}}
fact {
	all s: State, ss: s.next{
		AddItem in s.action implies ShowBasket in ss.action}}
fact {
	all s: State, ss: s.next{
		ShowBasket in s.action implies FinalizeOrder in ss.action}}
fact {
	all s: State, ss: s.next{
		FinalizeOrder in s.action implies EnterPayment in ss.action}}
fact {
	all s: State, ss: s.next{
		EnterPayment in s.action implies EnterDelivery in ss.action}}
fact {
	all s: State, ss: s.next{
		EnterDelivery in s.action implies ConfirmOrder in ss.action}}



fact {
	all s: State, ss: s.next{
				ss.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies ss.gainK[u] = s.gainK[u])
	}
}


pred ShowCatalog[s, ss : State]{
	one u : User |  
	ss.action = ShowCatalog &&
//	s.grant = u.session &&
	//Controlss Predicates
	ss.grant = u.session &&
	ss.checked = s.checked + NoData&&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB = u.catalog &&
	ss.writeDB = NoData &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = NoData &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData 
}

pred ShowItem[s, ss : State]{
	one u : User | 
	ss.action = ShowItem &&
	//s.showDB = u.catalog &&
//	s.grant = u.session &&
	//Controlss Predicates
	ss.grant = u.session &&
	ss.checked = s.checked + NoData  &&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB = NoData&&
	ss.writeDB = NoData &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = u.catalog.itemId  &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData
}



pred AddItem[s,ss : State]{
	one u : User |  
	//one i : s.showDB |
	//i in Id &&
	//s.showSD = u.catg.itemId  &alog.itemId  &&
	ss.action = AddItem &&
	//Controlss Predicates
	ss.grant = s.grant &&
	ss.checked = s.checked + NoData &&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB =  NoData &&
	ss.writeDB = NoData &&
	ss.edit = NoData &&
	ss.writeSD = u.basket &&
	ss.showSD = NoData &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData
}


pred ShowBasket[s,ss : State]{
	one u : User |  
	ss.action = ShowBasket &&
	//s.writeSD = u.basket &&
	//Controlss Predicates
	ss.grant = s.grant &&
	ss.checked = s.checked + NoData&&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB =  NoData&&
	ss.writeDB = NoData &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = u.basket &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData 
}



pred FinalizeOrder[s,ss : State]{
	one u : User | 
//	s.grant = u.session &&
	//s.showSD = u.basket &&
	ss.action = FinalizeOrder &&
	//Controlss Predicates
	ss.grant = s.grant &&
	ss.checked = s.checked +  u.basket &&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB = NoData &&
	ss.showDB =  NoData&&
	ss.writeDB = NoData &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = u.basket &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData 
}


pred EnterPayment[s,ss : State]{
	one u : User |  
//	s.grant = u.session &&
	ss.action = EnterPayment &&
	//Controlss Predicates
	ss.grant = s.grant &&
	ss.checked = s.checked + u.payment &&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB =  NoData &&
	ss.writeDB = u.payment &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = NoData &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData 
}

pred EnterDelivery[s,ss : State]{
	one u : User | 
	//one u : User |  one v : User |
	//s.grant = u.session &&
	ss.action = EnterDelivery &&
	//Controlss Predicates
	ss.grant = s.grant &&
	ss.checked = s.checked +  u.profile &&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB =  NoData  &&
	ss.writeDB = u.profile &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = NoData &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData
}


pred ConfirmOrder[s,ss : State]{
	one u : User |  
	//s.grant = u.session &&
	ss.action = ConfirmOrder &&
	//Controlss Predicates
	ss.grant = s.grant &&
	ss.checked = s.checked +  u.basket &&
	ss.PageIncluded = NoData &&
	ss.echo = NoData &&
	ss.exec = NoData &&
	//Web applicationss Events
	ss.showDB =  NoData &&
	ss.writeDB = u.basket &&
	ss.edit = NoData &&
	ss.writeSD = NoData &&
	ss.showSD = NoData &&
	ss.writeFS = NoData &&
	ss.showFS = NoData &&
	ss.AJAX = NoData
}


/*

assert CheckPaymentOLD {
	no s : State | some d : Payment | some x : User{
	d not  in s.checked &&
	s.grant = x.session &&
	ConfirmOrder in s.action
	}
}
*/
assert CheckPayment {
	no s : State | some d : Payment { //| some ss : State{
	ConfirmOrder in s.action  && s = last &&
	d not in s.checked //&&	lt[ss, s]
	}
}

assert CheckWorkFlow {
	no s : State { //| some ss : State{
	ConfirmOrder in s.action  && s = last
	}
}

check CheckWorkFlow for 4 State// 1 User, 20 Data
