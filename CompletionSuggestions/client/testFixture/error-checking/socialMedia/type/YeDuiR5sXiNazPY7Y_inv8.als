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

all a:Ad, u1:User, u2:User, u3:User | u1.sees = (u1.follows.posts or u1.suggested.posts)

}


