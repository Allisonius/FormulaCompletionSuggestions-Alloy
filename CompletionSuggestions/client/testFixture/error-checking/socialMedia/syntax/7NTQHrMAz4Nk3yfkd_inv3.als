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

all u1,u2 : User | u2.posts in u1.sees implies u2 in u1.follows

all a : Add | a in User.sees

}

