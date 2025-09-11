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

all u1, u2: User | all a: Add | u1->a in posts implies (u1->u2 in follows or u1->u2 in suggested)
}


