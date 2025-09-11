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

all u : User | all ad : Ad | all u_ad in u.sees.ad | u_ad.posts in u.follows || u_ad.posts in u.suggested

}


