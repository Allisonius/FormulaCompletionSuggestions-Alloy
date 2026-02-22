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
