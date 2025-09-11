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


}

run {
inv1,
inv2
}


pred inv2{

all user: User | user not in user.follows
}

pred inv1{

all p: Photo | one u: User | p in u.posts
}

