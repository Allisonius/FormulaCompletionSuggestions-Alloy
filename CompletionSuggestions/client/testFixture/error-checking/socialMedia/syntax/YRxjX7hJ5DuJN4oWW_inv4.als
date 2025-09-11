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

all u, i : univ | u in User and i in Ad and u->i in posts implies all p : univ | u->p in posts implies p in Ad
all u : User | one u.posts & Ad implies all u.posts & Ad

}

