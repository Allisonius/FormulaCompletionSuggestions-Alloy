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

pred inv1 {
	all p : Photo | one posts.p
}

pred inv2 {
	all p : User | p not in p.follows
}

pred inv3 {
	all p : User | p.sees - Ad in p.follows.posts
}

pred inv4 {
	all u: User | some u.posts & Ad => u.posts in Ad
}

pred inv5 {
	all i : Influencer | follows.i = User - 
}

pred inv6 {
	all i:Influencer, d:Day| d in i.posts.date
}

pred inv7 {
	all u : User | u.suggested = u.follows.follows - u.follows - u
}

pred inv8 {
	all a : Ad, u : User | a in u.sees => a in u.follows.posts or a in u.suggested.posts
}