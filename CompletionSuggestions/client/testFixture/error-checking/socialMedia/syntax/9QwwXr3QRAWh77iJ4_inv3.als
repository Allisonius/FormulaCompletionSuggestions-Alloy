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


all u : User, seenPhotos : u.sees | seenPhotos in Ad || (seenPhotos not in Ad && seenPhotos u.follows.posts)

}

