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






all u1 : User | all ph : Photo |
ph in u1.sees  implies ((some u2 : User | ph in u2.posts and some u2.u1.follows ) or ph  in Ad)


}

