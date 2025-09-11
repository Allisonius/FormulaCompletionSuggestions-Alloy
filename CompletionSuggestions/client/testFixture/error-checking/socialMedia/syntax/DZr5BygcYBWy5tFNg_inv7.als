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

all usr1, usr2:User | usr1->usr2 in follows some usr3:User | usr2->usr3 in follows implies usr1->usr3 in suggested

}

