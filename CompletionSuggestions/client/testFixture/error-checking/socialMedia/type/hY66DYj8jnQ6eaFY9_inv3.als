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


all u1 : User| some u2 : User | all p : Photo | u1->p in sees implies p in Ad or u2.posts and u2 in u1.follows


}

