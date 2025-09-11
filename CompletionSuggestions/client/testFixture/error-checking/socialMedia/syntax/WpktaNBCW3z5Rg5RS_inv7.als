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

all u1:User, u2:User, u3:User | u3 in u1.suggested implies (u3 not in u.follows and u3 in u.follows.follows)

}

