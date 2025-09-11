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

all a:Ad | some u:User | u -> a in sees implies (some p:User | p -> a implies u -> p in follows or u -> p in suggested)

}


