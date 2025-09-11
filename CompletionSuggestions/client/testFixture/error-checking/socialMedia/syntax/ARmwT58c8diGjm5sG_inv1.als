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

pred inv1{

all i : univ | i in  Photo implies some x : univ | x->i in posts
all p,y : univ | p in Photo implies some x,y : univ | x->p in posts and y->p in posts implies x==y

}

