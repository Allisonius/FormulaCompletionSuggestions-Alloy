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


all u:User  | some p: Photo - Ad | some x:User | (p in x.posts and p in u.sees) implies x in u.follows
all u:User | all p: Photo | (p in u.posts and p in u.sees) => false



}

