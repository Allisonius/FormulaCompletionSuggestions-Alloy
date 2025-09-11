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

pred inv4{

all u: User | all p1, p2: Posts | (p1 != p2 and p1 in Ad) implies p2 in Ad


}

