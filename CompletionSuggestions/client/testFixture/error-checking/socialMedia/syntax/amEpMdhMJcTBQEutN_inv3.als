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
all u : User, p : Photo | p in sees[u] <=> (p in posts[v] and v in follows[u]) or p in Ad
}

