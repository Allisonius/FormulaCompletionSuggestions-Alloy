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

all u : User | all a : Ad | a in u.sees implies some followed, suggest : univ | (followed->ad in posts and user->followed in follows) or (suggest->ad in posts and user->suggest in suggested)

}


