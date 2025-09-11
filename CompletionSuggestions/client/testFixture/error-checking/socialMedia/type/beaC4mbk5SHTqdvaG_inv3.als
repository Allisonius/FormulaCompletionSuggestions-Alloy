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


all u: User | all a: Ad | a in u.sees
all u1, u2: User | all p: Photo | u2 in u1.follows and p i u2.posts implies p in u1.sees

}

