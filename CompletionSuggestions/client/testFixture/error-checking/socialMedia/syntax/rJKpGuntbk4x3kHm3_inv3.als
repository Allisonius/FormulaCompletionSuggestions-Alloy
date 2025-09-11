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


(all u1,u2:User | all p:Photo | p not in Ad implies (u1->u2 in follows and u1->p in sees and u2->p in posts))
and
(all u3 : User | all p2 : Photo | p in Ad implies u3->p2 in sees)


}

