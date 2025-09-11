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

all disj u,uu: User-Influencer| u in uu.follows.follows and u not in uu.follows and u not in Influencer => u in uu.suggested


all u:User | u not in u.suggested
all i: Influencer, u:user |i not in u.suggested
}

