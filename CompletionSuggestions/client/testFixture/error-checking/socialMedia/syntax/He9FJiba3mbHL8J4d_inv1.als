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

all x,y,z : univ | x in Photo implies y in User and z in User and y->x in posts and z->x in posts and z = y
all

}

