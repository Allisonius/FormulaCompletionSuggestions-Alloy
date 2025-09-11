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


all p : Photo | p in u.sees => (p in u.follows.posts and p not in Ad)
all u : User | all a :Ad | a in u.sees

}

