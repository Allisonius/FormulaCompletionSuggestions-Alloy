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


all u: User, u2: User, y: Photo | (y not in Ad and u->y in sees and u2->y in posts) implies (u->u2 in follows)
all u: User, y: Ad | x->y in sees

}

