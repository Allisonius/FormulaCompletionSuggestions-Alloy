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

all u1, u2: User, p1 : Photo | u1->p1 in (posts or sees) and u2->p1 in posts implies u1=u2

}

