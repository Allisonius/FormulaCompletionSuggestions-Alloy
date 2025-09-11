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



all u : User, p : Photo, us : User | u -> p in sees implies (p in Ad || (us->p in posts implies u->us in follows)

}

