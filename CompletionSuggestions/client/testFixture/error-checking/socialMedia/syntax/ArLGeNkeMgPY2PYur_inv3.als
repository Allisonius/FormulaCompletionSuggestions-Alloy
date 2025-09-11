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


all a : Ad, u:User | u->a in sees
all u1, u2 : User, p:Photo | u1 -> p in sees u2 -> p in posts implies u1->u2 in follows

}

