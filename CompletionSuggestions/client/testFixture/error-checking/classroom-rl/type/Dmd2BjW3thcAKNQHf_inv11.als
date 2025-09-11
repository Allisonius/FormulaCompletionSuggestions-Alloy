sig Person  {
	Tutors : set Person,
	Teaches : set Class
}
sig Group {}

sig Class  {
	Groups : Person -> Group
}

sig Teacher in Person  {}

sig Student in Person  {}

pred inv11{
    
	all c : Class | (#c.Groups > 0) => (#(Teaches.c & Teacher) > 0) ' #c.Groups = 0
}

