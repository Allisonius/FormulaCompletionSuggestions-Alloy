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

all user : User | user not in user.suggested
all user1, user2, user3 : User | user1 != user2 != user3 and ((user3 not in user1.follows) and (user3 in user2.follows) and (user2 in user1.follows)) implies user3 in user1.suggested
}

