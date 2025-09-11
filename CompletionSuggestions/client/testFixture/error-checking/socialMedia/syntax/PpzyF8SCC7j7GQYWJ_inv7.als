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

pred inv7{



all x,y: User | y in x.suggested <=> ( some z: User | y in z.follows && z in x.follows && y not in x.follows) && x!=y && y!=z
}

