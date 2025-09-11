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

all i:Influencer, d1, d2: Day, p1,p2: Photo | (i->p1 posts and i->p2 in posts and p1->d1 in date and p2->d2 in date) => d2 = d1+1

}

