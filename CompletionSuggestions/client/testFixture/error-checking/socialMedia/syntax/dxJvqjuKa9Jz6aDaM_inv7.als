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





all i: Influencer, u: User |i not in u.suggested
all u: User | u in User.follows and => u in User.suggested
all u: User | not (u in User.follows) => not (u in User.suggested)
all u: User | u not in u.suggested
}

