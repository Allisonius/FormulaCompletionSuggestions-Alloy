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

all a:Ad,u1,u2:User | a in u1.posts and a in u2.sees implies u1 in u2.follows or u1 in u2.suggeted
}


