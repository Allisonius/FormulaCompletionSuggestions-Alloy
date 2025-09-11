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


all u,f : User ,p, s : Photo | u -> s in sees implies some p | u-> f in follows and f -> p in posts or some a : Ad s = a


}

