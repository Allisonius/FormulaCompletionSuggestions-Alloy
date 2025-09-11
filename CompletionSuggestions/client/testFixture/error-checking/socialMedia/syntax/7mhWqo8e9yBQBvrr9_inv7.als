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

all u : Users | all u_followed : follows.u | all sugg : follows.u_followed | sug not in follows.u => sug in u.suggested
}

