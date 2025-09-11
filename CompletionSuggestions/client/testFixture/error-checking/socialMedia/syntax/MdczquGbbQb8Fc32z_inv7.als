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

pred inv7{
all u : User | all v : User | v in suggested[u] => (v in follows[w] and w in follows[u] and not v in follows[u])
}

