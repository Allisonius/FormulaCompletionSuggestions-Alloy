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

pred inv5{



all infl:Influencer, usr:User | usr != infl implies usr->infl in follows


all infl:Influence | some u:User | u->infl in follows implies u not in Influencer

}

