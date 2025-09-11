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

all a: Add, u,x: User | u->a in sees and x->a in posts implies u->x in follows or u->x in suggested

}


