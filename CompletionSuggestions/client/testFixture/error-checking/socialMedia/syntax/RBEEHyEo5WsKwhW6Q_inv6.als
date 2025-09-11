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

pred inv6{

all disj p1: Photo, p2: Photo | i: Influencer | p1 in i.posts && p2 in i.posts => p1.date != p2.date
}

