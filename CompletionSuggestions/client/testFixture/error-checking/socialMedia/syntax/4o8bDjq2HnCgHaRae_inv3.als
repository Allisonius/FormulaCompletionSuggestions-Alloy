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



All x:User, y: Photo-Ad|  x-> y in sees implies ( some z:User| x->z in follows and z-> y in posts)

}

