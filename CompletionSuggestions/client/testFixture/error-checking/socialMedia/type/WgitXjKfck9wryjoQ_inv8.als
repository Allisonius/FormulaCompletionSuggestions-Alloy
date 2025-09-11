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

all u1, u2 : User, a: Ad | a in u1.sees => a^(user) in u1.follows or  a^(user) in u1.suggested

}


