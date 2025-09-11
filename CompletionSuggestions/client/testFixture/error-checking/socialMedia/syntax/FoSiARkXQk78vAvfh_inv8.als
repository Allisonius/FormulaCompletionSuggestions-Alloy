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

all u : User | all a : Ad | u->a in sees implies ((one v : User | v->a in posts and (u->v in follows) or (u->v in suggested))


}


