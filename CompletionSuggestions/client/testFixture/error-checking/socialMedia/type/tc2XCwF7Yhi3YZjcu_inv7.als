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

all u:User| u not in u.suggested
all u1,u2:User| u2 in u1.follows implies u2 not in u1.suggested
all u1,u2:User| u2 in u1.suggested implies u2 not in Influencer
all i:Influencer | none i.suggested
all u1,u2:User| (u2 in u1.follows.follows and u2 not in u1.follows) implies (u2 in u1.suggested)
}

