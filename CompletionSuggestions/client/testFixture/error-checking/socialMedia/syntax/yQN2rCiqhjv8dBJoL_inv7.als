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

pred inv7{

all x, y, z : univ | x->y in follows and y->z in follows and not x->z in follows implies x->z in suggested and not x->y in suggesdted
}

