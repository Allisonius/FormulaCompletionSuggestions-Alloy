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

all a:Ad | u:User | a in u.sees implies some u2:User | a in u.posts and u2 in u.suggested or u2 in u.follows

}


