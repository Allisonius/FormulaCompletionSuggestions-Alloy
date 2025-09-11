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

all u,y: User | y in u.suggested implies  (u != y and
( y not in u.follows) and
(some z : User | (y in z.follows) and (z in u.follows))
}

