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

all user : univ | user in User and some ad : user->ad in posts and (ad in Ad) implies all photo : univ | photo in Photo and user->photo in posts and photo in Ad
}

