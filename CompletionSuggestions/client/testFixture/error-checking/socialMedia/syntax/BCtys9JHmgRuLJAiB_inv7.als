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

all u,x,y : User | u -> x in follows and x -> y in follows and u != x and u != y and x != y and u -> y and y-> x not in follows and not in follows iff u -> y in suggested

}

