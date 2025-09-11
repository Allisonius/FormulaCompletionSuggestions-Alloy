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
u1 -> ph in sees -> ((some u2 : User | ph in u2.posts and u1 -> u2 in follows ) or ph in Ad)

}

