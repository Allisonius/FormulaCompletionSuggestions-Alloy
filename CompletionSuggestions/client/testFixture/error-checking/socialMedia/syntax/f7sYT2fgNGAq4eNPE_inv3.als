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


all u,f : User,p,s : Photos ,a : Ad | u -> s in sees implies u-> f in follows and f -> p in posts and s = p  or s = a


}

