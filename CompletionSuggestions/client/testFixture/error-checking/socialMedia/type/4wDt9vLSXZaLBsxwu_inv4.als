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


all u:User, p : Photo | p in Ad and u->p in posts implies (all ph : Photo | u->ph in posts implies ph in Ad)


all u:User| one u.posts in Ad implies (all p : Photo | u.posts.p in Ad)

}

