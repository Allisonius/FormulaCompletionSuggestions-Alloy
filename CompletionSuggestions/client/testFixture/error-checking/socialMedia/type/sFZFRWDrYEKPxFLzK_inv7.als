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

all u, v,w: User| u and v in Influencer and u->v in follows and u->w not in follows implies v->u in suggested and v->w in suggested

}

