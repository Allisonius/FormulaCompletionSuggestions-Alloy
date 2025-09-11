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

all user : User + Influencer| user not in user.suggested
all user1, user2 : User + Influencer | (user2 in user1.follows) implies user2 not in user1.suggested
all user1, user2, user3 : User + Influencer | ((user2 in user1.follows) and (user3 in user2.follows)) implies user3 not in suggested
}

