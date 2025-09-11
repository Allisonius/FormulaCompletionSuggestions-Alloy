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



all x:User, x2:User, y:Photos | y in x.sees implies (y in Ad or  u->p in sees and u->u2 in follows)



}

