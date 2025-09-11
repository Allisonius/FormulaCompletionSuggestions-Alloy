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


all x,y: User, f:Photo, a:Ad | f in x.sees and f in y.posts implies (f not Ad && y in x.follows) || (f = a)



}

