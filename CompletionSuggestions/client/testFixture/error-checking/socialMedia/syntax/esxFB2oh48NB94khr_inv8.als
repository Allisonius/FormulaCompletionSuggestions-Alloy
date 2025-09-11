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

all ad:Ad,u:User| ad in u.sees implies ad in (u.follows.posts + u.suggested.posts
}


