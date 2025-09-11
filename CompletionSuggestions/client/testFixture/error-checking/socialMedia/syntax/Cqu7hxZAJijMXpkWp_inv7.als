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

all disj x,y,z : User | x->y in follows and y->z in follows and x->z not in follows implies x->z in suggested
all x,y : User | x->y in suggested implies x != y and x->y not in follows and some z : user | x->z in follows and z->y in follows




}

