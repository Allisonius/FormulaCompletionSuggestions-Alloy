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

all u1,u2:User a:Ad | u1->a in sees and u2->a in posts and u2!=u1 => (u1->u2 in suggested or u1->u2 in follows)

}


