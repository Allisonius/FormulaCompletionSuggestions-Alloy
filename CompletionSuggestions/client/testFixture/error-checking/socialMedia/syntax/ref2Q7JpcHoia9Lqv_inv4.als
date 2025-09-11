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

pred inv4{

all x: User | all y: ad | x in posts.y implies (all z: Photo | x in posts.z implies z in Ad )

}

