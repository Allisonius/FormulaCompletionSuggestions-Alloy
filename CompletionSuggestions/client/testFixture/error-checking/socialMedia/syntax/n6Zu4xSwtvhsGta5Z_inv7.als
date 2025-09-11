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

pred inv7{

all x,y : User | x!=y and y in x.suggested implies (x not in follows.y) and
( some x : User | z in follows.y and z in x.follows and z!=y) and

}

