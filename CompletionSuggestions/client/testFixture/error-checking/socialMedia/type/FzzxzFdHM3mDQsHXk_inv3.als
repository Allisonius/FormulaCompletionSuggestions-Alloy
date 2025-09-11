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



all x:User, p:Photo| x->p in sees and p not in Ad implies all u:User| x->u in follows and u->p in u.posts

}

