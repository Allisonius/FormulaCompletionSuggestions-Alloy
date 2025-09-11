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

pred inv5{

all u1,u2: User | u1!=u2 and u1 in Influencer implies (u2.follows.u1)

}

