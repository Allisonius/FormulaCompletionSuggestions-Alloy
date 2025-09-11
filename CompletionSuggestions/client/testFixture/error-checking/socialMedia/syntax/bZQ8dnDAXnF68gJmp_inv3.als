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

all x : User | all z: User |all y: Photo | x in follows.z and y not in Ad and y in z.posts and all see.y


}

