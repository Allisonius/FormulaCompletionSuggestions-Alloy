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


all u, j : User | all p : Photo | u -> p in sees implies u -> j in follows
all u : User| all i : Influencer| all p : Photo | u -> p in sees implies u -> i in follows



all u : User | all  a : Ad | u -> a in sees implies u -> a not in posts
all i : Influencer | all  a : Ad | i -> a in sees implies u -> a not in posts


}

