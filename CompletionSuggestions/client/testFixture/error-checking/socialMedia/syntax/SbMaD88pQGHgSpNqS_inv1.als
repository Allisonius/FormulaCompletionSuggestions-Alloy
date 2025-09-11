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

pred inv1{

all p: Photo | one x : User | x -> p in posts

all p: Photo | some x : User | x -> p in posts implies y in Ad or all z : User | z -> p in posts implies x->z in follows

}

