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

pred inv7{


all e: User - (o + s), o: User - (e + s), s: User - (e + o) | s in o.follows => s in e.suggested
}

