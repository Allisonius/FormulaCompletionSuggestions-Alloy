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


all, v, u:User, a:Ad | v->a in sees and u->a in posts implies v->u in follows or v->u in suggested

}


