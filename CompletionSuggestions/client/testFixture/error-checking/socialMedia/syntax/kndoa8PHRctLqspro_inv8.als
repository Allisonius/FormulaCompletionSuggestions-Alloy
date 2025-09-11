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

all u1,u2:User | u1 != u2 and u2 not in u1.follows   implies u2.posts:>Ad not in u1.sees
all u1,u2:User | u1 != u2 andu2 not in u1.suggested implies u2.posts:>Ad not in u1.sees

}


