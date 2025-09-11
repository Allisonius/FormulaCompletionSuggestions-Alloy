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

all u:User, a:Ad | u -> Ad in sees implies (all u1:User | u -> u1 follows or u -> u1 suggested)

}


