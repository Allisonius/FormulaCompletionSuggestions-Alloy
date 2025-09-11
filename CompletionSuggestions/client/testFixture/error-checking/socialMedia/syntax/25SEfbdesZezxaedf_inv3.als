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


all u: User, p : Photo | u -> p in sees =>
p in Ad || some f : User | u->f in follows && f->p in posts

all u: User, p: Photo | u -> p in sees => p in Ad+u.follows.pos

}

