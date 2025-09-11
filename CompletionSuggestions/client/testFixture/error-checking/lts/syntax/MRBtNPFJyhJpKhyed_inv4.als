sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv4{
  let adj={x,y:State | some e:Event |x->e->y in trans}
  
  all i:Init |(State-Init) in i.^adj

  
}

/*
All the states have the same events available.
*/

