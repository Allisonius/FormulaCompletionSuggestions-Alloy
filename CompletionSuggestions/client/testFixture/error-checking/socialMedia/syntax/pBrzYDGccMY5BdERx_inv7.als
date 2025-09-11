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

all user, suggest : univ | user in User and suggest in User and user->suggest in suggested implies some followed : followed->suggest in follows
}

