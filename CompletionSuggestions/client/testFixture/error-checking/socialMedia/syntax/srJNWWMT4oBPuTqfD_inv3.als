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

all u : User | (u.sees not in Ad) implies ((p in u.sees) and (p in (u.follows).posts)))






}

