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

all x : Photo | some z : User | x in z.post and all y, z : User | x in y.posts and x in z.posts implies y = z


}

