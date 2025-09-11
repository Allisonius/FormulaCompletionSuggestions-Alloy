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

all x,y,z : univ | x in User and z in User and y in Photo and posts(x,y) and posts(z,y) implies x=z

}

