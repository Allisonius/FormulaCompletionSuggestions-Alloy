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


all u:User, ad:Ad, f:Influencer, s:User | u->p sees implies ((f->p in posts and u->f in follows) or (s->p in posts and u->s in suggested))
}


