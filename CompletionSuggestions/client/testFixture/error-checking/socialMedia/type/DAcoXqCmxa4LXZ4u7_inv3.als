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



all u1,u2:User, p:Photo | p.posts.u1 implies p not in Ad
all p:Photo , a: Ad , u:User | u.sees.p implies p in Ad



}

