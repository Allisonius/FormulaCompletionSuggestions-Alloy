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

all u : User | all a : ads | u in sees.a implies
( one y : User | y in posts.a and
(u in follows.y ) or
(y in suggested.x)
)


}


