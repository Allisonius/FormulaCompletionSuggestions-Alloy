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

all photo: Photo | photo in User.posts
all user1, user2: User | ( photo in user1.posts and photo in user2.posts) implies user1 = user2
}

