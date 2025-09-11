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

all u : User | some ad : Ad, i : User | ad in u.sees implies (i in u.follows and ad in i.posts) or (i in u.sugested and ad in i.posts)
}


