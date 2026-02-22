abstract sig Person {}

sig Student extends Person {}

sig Professor extends 

sig Class {
	assistant_for: set Student,
	instructor_of: one Professor
}

sig Assignment {
	associated_with: one Class,
	assigned_to: some Student
}