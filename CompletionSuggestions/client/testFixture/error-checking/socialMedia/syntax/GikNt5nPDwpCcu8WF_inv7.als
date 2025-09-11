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

all a, b : User | b in a.suggested iff a != b and some c : User | b in c.follows and c in a.follows and b not in a.follows

}

