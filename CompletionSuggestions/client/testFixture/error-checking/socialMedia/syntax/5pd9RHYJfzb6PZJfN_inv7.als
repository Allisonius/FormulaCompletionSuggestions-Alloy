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



all u : User | all s: u.follows | all y: s.follows | y not in u.follows implies y in u.suggested and u!=s,y  and s!=u and s!=y

}

