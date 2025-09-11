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

all u:User,a:Ad | a in u.sees implies (some u1:User | a in u1.posts and u1 in u.follows or u.suggested)
}


