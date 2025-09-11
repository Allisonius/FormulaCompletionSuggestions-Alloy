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


all u1:User | all p:Photo | u1->p in posts implies((some u2 | u2 -> p in sees implies u2 -> u1 in follows) or ph in Ad)
}

