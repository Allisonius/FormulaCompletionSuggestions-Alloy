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

all u : User | some p : Photo | p in Ad and u->p in posts implies all v : Photo | u->v in posts | v in Ad

}

