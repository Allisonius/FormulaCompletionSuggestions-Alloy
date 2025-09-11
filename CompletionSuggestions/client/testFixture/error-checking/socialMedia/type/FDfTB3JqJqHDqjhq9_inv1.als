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

all x : Photo | all y,z : User | x in y.posts implies x not in z.posts
all ad : Ad | all x : User | ad implies ad not in x.posts
}

