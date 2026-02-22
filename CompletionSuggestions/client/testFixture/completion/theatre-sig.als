open util/ordering[Time]	

sig Time{}

//=================
//  Pre-defined Sets
//=================

sig CLIENT {}
sig THEATRE {}
sig PLAY {}
sig NAME {}
sig EMAIL {}
sig PERFORMANCE {}
sig RESERVATION {}


//================
// Instances
//================

sig Client extends CLIENT {  //R1	
	name: one NAME, //R2
	email: EMAIL one->Time //R2
	
}

sig Theatre extends THEATRE {  //R9
	number_of_seats: Int one->Time //R10
}

sig Play extends PLAY {  //R13
	duration: one Int 
}

sig Performance extends PERFORMANCE {  //R15	
	play: one PLAY, //R16
	theatre: one THEATRE, //R16
	begin_time: one Int, //R16
	end_time: one Int, //R16
	available_seats: Int one -> Time
}

sig Reservation extends RESERVATION {  	
	client: one CLIENT, //R21
	num_reserved_seats: Int one->Time, //R21 
	performance: one PERFORMANCE //R21
}


//================
// Theatre registered
//================	
 
one sig ClientsRegistered {clients: Client->Time}

one sig ClientsBanned {clients: Client->Time}

one sig TheatresRegistered {theatres: Theatre->Time}

one sig PlaysRegistered {plays: Play->Time}

one sig PerformancesRegistered {performances: Performance->Time}

one sig ReservationsRegistered {reservations: Reservation->Time}
