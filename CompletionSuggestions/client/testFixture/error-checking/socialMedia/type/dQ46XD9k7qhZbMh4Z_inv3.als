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

all u1, u2 : User, p : Photo , a : Ad | (p != a && u1 in posts.p && u2 in sees.p) implies (u2 in follows.u1)

all u : User, a : Ad | u -> a

}

