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

all x,y,z : univ | (x->y in sees and y in Ad) implies z->y posts and (x->z in infollows or y->x in suggested)

}


