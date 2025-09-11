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


all x, y, z: User | x in y.follows && y in z.follows && x not in z.follows && y != x && x y != z => x in z.suggested
}

