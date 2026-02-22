abstract sig Color {}
one sig Red extends Color {}
one sig Blue extends 

sig Node {
  neighbors: set Node,
  color: one Color 
}