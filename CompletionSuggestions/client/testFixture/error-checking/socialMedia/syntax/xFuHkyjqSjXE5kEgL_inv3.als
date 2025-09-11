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


all u : User | some u2:User | all ph : Photo | ph in u.sees implies
(
(ph not in Ad and (ph in u2.posts and u2 in u1.follows))
or
(ph in Ad)
)

}

