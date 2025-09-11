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

all x: User, a: Ad | x -> a in sees implies all z: User | z -> a in posts implies x -> z in follows or x -> z in suggsted
}


