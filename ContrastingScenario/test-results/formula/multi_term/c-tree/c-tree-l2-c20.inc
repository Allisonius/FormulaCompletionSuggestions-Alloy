abstract sig Color {}
one sig Red extends 
one sig Blue extends Color {}

sig Node {
  neighbors: set Node,
  color: one Color 
}