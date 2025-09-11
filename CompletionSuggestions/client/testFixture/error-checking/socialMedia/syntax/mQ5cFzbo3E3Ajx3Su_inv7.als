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




all i :
all u,s : User | u->s in suggested and u!=s implies some u2 : User | u2!=u and u2->s in follows and u->u2 in follows and u->s not in follows

}

