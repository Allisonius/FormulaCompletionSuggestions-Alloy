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

pred inv8{

all ad : Ad | all u,u2 : User | ad in u.sees implies (u2 in u1.follows or u2 in u1.suggested)

}


