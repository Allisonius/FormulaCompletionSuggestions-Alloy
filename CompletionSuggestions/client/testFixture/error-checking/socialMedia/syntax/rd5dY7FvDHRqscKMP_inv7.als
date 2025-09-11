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

all x,z : User | x->z in suggested iff(x!=z and x->z not in follows and some y:User| x->y in follows and y->z in follows

}

