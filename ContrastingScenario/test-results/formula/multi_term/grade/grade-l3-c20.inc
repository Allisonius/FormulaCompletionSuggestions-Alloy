abstract sig Person {}

sig Student extends 

sig Professor extends Person {}

sig Class {
	assistant_for: set Student,
	instructor_of: one Professor
}

sig Assignment {
	associated_with: one Class,
	assigned_to: some Student
}