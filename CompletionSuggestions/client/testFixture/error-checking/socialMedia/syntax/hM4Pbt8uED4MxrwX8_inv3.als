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
u1->ph in sees  implies ((some u2 : User | u2->p in posts and u2 in u1.follows ) or ph  in Ad)

}

