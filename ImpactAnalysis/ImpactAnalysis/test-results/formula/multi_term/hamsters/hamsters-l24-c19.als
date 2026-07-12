module HAMSTERS

abstract sig Task {}
abstract sig Atomic extends Task {
	var guard : lone True
}
one sig True {}
abstract sig Composite extends Task {
	subtasks : seq Task
}
abstract sig Disable, Suspend, Concurrent, Choice extends Composite {}

abstract sig Sequence extends Composite {
	var log : seq Task
}

one sig Root in Task {}
sig Iterative, Optional, Input in Task {}

sig Erroneous in Atomic {}

var sig executed, enabled, running, finished, done in Task {}

var sig Enabled in 
