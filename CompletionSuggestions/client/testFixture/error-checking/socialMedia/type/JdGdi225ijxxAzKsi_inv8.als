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

all u : User, p : Photo |
p not in Ad and p in u.sees implies
p in u.follows.posts and p not in u.follows.posts.Ad or
p in u.suggested.posts and p not in u.suggested.posts.Ad
all u : User, p : Ad |
p in u.sees implies
p in u.follows.posts.Ad or
p in u.suggested.posts.Ad

}


