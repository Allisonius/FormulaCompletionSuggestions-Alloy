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





posts in User lone -> Photo
posts in User some -> Photo

posts in User one -> Photo
}

check Injetivicade {
(all p:Photo, u1,u2: Uesr | u1 -> p in posts and u2->p in posts => u1 = u2)
iff
(posts in User lone -> Photo)
} for 5

