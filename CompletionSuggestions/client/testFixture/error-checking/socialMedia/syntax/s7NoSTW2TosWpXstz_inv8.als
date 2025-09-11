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

pred inv8{

all u:User, poster:User, a:Ad | u->a in sees and poster->a in posts implies (u->poster in follows or u->posted in suggested)
}


