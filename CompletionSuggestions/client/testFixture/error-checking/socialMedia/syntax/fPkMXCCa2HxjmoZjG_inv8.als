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

all u: User, u2: User, a: Ad | u->a in sees and u2->a in posts implies (u->f in follows or u->f in suggested)

}


