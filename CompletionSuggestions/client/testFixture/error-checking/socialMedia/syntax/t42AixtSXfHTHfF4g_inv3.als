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


all u,u1:User | all p:Photo | p in u.posts and p in u1.sees implies u in u1.follows
all a : Ad | all u : User|  implies a in u.sees

}

