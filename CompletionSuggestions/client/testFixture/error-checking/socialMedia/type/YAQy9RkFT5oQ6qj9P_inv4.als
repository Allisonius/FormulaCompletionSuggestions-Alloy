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


all u:User, p : Photo | u->p in posts and p in Ad implies (all ph : Photo | u.posts implies ph in Ad)

}

