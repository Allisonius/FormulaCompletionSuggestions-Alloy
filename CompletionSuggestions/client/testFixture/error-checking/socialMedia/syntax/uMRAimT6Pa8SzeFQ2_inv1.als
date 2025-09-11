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

pred inv1{

all p:Photo | some u:User | (p in u.posts and (all u2:User | (u2 == u) or (p not in u2.posts)))

}

