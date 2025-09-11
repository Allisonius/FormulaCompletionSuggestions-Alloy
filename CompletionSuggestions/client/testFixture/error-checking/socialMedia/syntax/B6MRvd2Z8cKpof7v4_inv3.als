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



all x, y: User | all z:Photo | x-> z in sees implies x-> y in follows and y->z in posts and z not in Ad
all x: User| all y: Ads| x -> y in sees

}

