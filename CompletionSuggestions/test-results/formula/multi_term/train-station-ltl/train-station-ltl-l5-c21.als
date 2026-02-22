sig Track {
	prox : set Track,
	signal : lone Signal
}
sig Junction extends 
sig Entry, Exit in Track {}

sig Signal {}
var sig Green in Signal {}

sig Train {
	var pos : lone Track
}