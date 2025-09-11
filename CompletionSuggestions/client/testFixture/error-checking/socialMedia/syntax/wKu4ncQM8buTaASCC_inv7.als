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

all u : Users | all s : u.suggested | s not in u.followed and (some ufoll in u.followed | s in ufoll.followed)

}

