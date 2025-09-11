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

all x,y: User  | all a : Ad | (x in sees.a) implies ((y in posts.a) and ((y in follows.x) or (y in suggested.x))

}


