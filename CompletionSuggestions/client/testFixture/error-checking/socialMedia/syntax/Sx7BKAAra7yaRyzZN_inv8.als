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

all u : User, ad Ad |  u.sees.ad in u.follows.posts  or  u.sees.ad in u.follows.suggested

}


