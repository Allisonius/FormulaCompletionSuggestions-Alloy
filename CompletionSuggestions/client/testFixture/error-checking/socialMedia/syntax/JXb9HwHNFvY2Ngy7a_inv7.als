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

pred inv7{


all x:User,t:User-x,k:User-t| x->k in suggested implies x->t in follows and t->k in follows and x!=K

}

