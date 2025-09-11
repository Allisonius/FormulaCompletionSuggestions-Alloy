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

all u: User, a: u.sees | (Ad in a) in u.follows.posts or (Ad in a) in u.suggested.posts

}


