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


for all p : Photos | p in u.sees => (p in u.follows.posts and p not in Ad)
for all u : User | for all a :Ad | a in u.sees

}

