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

all u: User, ad : Ad |
some f, s : User |
u->ad in sees
=> (f->ad in posts && u->f in follows)
(s->ad in posts && u->s in suggested)
}


