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

pred inv1{

(all p : Photo | some u : User | u->p in posts) &&
all u1,u2 : User | one p : Photo| u1->p in u1.posts and u2->p in u2.posts implies u1 = u2

}

