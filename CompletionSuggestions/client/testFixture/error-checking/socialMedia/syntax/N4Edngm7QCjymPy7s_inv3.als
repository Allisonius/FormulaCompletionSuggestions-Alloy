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


User.sees = User.follows.posts + Ad + User.posts - User.suggests
Influencer.sees = Influencer.follows.posts + Ad + Influencer.posts

}

