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


all x,y,z : univ | x in User and x->y in sees implies y not in Ad and z in User z->y in posts and x->z in follows else y in Ad


}

