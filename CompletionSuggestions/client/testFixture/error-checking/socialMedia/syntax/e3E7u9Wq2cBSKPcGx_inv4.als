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

pred inv4{

some a : Ad, all u : User | u -> a in posts => not some p : Photo | u -> p in posts and p not in Ad


}

