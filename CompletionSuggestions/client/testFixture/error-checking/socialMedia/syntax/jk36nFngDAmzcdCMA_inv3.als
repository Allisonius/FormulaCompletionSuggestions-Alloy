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

all p : Photo - Ad, u1,u2 in User | u1.sees.p and u2.posts.p implies u1.follows.u2



}

