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

all u:User | all a:Ad | a in u.sees implies some p:User | p in (u.follows + u.sugessted) and  a in p.posts
}


