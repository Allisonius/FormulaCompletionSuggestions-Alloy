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

all a:Ad | some u:User | s in u.sees implies one u1:User | (u1 in u.follows or u1 in u.suggested) and a in u1.posts
}


