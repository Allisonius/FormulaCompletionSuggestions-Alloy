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

all ad : Add | all u1, u2: User | ad in u1.posts and ad in u2.sees implies u1 in u2.follows or u1 in u2.suggested

}


