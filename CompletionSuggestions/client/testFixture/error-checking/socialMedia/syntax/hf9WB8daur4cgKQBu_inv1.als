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

pred inv1{


all p : univ | p in Photo implies some u : univ | u in User and u in posts.p
all p : univ | some u1, u2 : univ | p in Photo and u1 in posts.p and u2 in posts.p imples u1 = u2




}

