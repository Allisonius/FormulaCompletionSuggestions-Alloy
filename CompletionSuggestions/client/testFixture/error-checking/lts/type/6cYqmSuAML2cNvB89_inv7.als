sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

pred inv7{

  let adj ={x,y:State | some e:Event |x->e->y in trans} |
  
  some Init in (Init.^adj).^adj
  
	
}


