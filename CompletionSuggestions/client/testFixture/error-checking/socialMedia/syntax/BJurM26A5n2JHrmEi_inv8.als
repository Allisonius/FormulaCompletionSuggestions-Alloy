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

all u:User , a:Ad | u -> a in sees implies (some u2: User (u2 -> a in posts) && (u2 in (u.follows || u.suggested)))

}


