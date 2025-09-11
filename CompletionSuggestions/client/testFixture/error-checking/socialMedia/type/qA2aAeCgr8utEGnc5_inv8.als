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

all x, y : univ | x in User and y in Ad and x->y sees and z->y in posts implies x->z in follows or x->z in suggested
}


