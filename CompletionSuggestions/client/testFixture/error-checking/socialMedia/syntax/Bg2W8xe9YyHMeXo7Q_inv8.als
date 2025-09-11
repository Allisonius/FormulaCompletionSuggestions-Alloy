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

all u1, u2 : User | (u1.post in Ad and u1.post in u2.sees) implies (u1 in u2.follows or u1 in u2.suggested)

}


