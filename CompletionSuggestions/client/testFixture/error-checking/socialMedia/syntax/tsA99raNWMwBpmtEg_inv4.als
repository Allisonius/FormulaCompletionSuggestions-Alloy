sig User {
	follows : set User,
	sees : set Photo,
	posts : set Photo,
	suggested : set User
}

sig Influencer extends User {}

sig Photo {
	date : one Day
}
sig Ad extends Photo {}

sig Day {}

pred inv4{


all a:Ad, u:User | u->a in posts implies (some p:Photo u->p in posts and p in Ad)

}

