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

pred inv3{


all u,u2:User | all p:Photo | u != u2 and u->u2 in u.follows and u->p in sees implies (u2->p in posts )
}

