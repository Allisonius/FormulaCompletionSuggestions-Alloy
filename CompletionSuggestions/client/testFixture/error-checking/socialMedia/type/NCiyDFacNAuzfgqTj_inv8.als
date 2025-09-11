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

all a : Ad, u : User | a in u.sees implies a in (u.follows.posts + u.suggested.posts)

sees = Ad - (follows.posts + suggested.posts)

}


