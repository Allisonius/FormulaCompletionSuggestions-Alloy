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


all x: User | all y: Ad | x->y in sees
all x: User | all y: Photo | y in x.sees implies one z in y.posts and z in x.follows

}

