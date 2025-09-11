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

pred inv6{

all i:Influencer, d1, d2: Day, p1,p2: Photo | p1->i posts and p2->i in posts and p1->d1 in date and p2->d2 in date => d2 = d1+1

}

