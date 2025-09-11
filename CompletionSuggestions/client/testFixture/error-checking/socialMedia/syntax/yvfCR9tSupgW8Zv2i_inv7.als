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

all u, i : User | i in u.suggested implies some o : User | o in u.follows and i in o.follows and i!=o and u!=i and U!=o

}

