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

all x: User | all z: User-x| x in z.suggested => x not in z.follows && some y: z.follows | x in y.follows && x!=y)

}

