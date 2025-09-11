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


all u:User | some p:Post | u->p in posts and p in Ad implies all p1:Photo | u -> p in Ad

}

