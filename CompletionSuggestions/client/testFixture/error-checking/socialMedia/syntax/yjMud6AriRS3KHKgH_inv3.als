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

pred inv3{


all add:Ad, all p:Photo, all u1,u2: User| p in u1.sees implies (p not in Ad p in u2.posts) else p in Ad
}

