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

all p:Photo | all u:User | p in u.sees and p in Ad implies some u2:User | a in u2.posts and u2 in u.suggested

}


