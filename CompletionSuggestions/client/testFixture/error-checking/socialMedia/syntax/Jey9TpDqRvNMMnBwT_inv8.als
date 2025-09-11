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

all u : User, ad : Ad | ad in u.sees implies (some u2 : User | ad in u2.posts && (u2 in u.follows or u2 in u.suggested)
}


