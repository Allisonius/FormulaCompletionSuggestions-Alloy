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

all x:User | x.sees in Ad implies x.sees in x.follows.posts or x.sees in x.suggested.posts
}

















all n:Node-Leaf | #n.children = 2


