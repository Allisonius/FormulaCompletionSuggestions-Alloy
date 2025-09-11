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

pred inv6{

all i:Influencer | all p1,p2:Photo | p1 != p2 and i->p1 in i.posts and i->p2 in i.posts implies p1.date != p2.date
}

