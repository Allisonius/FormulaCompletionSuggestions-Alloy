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

pred inv4{

all a: Ad | all ps in posts.a.posts | ps in Ad
all u: User | some p: u.posts | (p in Ad) -> all ps in u.posts

}

