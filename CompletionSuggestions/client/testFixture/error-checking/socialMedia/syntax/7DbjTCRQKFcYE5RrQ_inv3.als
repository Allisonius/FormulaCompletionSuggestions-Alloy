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


all p : Photo - Ad, u : User | p in u.sees implies ( some u2 : User | u2 in u.follow && p in u2.posts)

}

