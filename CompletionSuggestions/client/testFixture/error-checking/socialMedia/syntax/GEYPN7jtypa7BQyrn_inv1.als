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

pred inv1{

all p:Photo, u1,u2: User | (u1->p in Photos and u2->p in Photos) => u1 = u2
all p:Photo | some u: User | u->p in Photos
}

