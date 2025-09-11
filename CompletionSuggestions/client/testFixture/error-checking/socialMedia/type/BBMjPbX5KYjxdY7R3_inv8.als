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

all u1,u2 : User| all p:Photo| p in Ad and (u2->p in posts and (u1->u2 in follows or u1->u2 in suggested)) in sees implies u1->p



}


