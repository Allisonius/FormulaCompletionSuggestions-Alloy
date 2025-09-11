sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
no Init  implies no State and  all i :Init|(State-Init).^~(i.trans)
}

/*
All the states have the same events available.
*/

