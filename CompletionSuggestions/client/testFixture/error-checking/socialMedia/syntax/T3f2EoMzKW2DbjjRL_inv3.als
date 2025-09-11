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


all u:User | some p:Photo-Ad | u1->p in sees implies some u2:User| u2->p in posts and u1->u2 in follows

}

