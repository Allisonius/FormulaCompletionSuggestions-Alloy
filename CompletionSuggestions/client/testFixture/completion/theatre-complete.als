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

//================
// Initialization
//================

pred init[t: Time] {

	no ClientsRegistered.clients.t //R7
	no ClientsBanned.clients.t //R8
	no TheatresRegistered.theatres.t //R11
	no PlaysRegistered.plays.t //R14
    no PerformancesRegistered.performances.t //R20
	no ReservationsRegistered.reservations.t
}

//=====================
// Unaltered states
//=====================

pred unalteredClientsRegistered [t, tt: Time]{
	ClientsRegistered.clients.tt = ClientsRegistered.clients.t
}

pred unalteredClientsBanned [t, tt: Time]{
	ClientsBanned.clients.tt = ClientsBanned.clients.t
}

pred unalteredTheatresRegistered [t, tt: Time]{
	TheatresRegistered.theatres.tt =TheatresRegistered.theatres.t
}

pred unalteredPlaysRegistered [t, tt: Time]{
	PlaysRegistered.plays.tt = PlaysRegistered.plays.t
}

pred unalteredPerformancesRegistered [t, tt: Time]{
	PerformancesRegistered.performances.tt = PerformancesRegistered.performances.t
}

pred unalteredReservationsRegistered [t, tt: Time]{
	ReservationsRegistered.reservations.tt = ReservationsRegistered.reservations.t
}

//================
// Operations - Client
//================

pred addClient[c: Client, t, tt: Time]{
	let cr = ClientsRegistered.clients{
		let cbanned = ClientsBanned.clients{
			!(c in cr.t) //R1 R6
			!(c in cbanned.t) //R5 R6
			all clients : cr.t | c.email != clients.email //R3
			cr.tt = cr.t + c

			//Not changed
			all cli : cr.t | cli.email.tt = cli.email.t
	
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred removeClient[c: Client, t, tt: Time]{
	all reservation : ReservationsRegistered.reservations.t | reservation.client != c  //R24
	let cr = ClientsRegistered.clients{
		let cbanned = ClientsBanned.clients{ 
			!(c in cbanned.t) //R6
			c in cr.t //R4 R6
			cr.tt = cr.t - c
		
			//Not changed
			all cli : cr.tt | cli != c => cli.email.tt = cli.email.t
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred banClient[c: Client, t, tt: Time]{ //R5
	let cr = ClientsRegistered.clients{
		let cbanned = ClientsBanned.clients{ 
			let rr = ReservationsRegistered.reservations{
				(c in cr.t) //R6
				!(c in cbanned.t) //R6
				
		 	    all reservation : ReservationsRegistered.reservations.t | reservation.client = c => reservation.performance.available_seats.tt =	add[reservation.performance.available_seats.t, reservation.num_reserved_seats.t] // R26
				rr.tt = rr.t - client.c				

				cr.tt = cr.t - c
				cbanned.tt= cbanned.t + c
			
				//Not changed
				all cli : cr.tt | cli != c => cli.email.tt = cli.email.t
				all reservation : ReservationsRegistered.reservations.t | reservation.client != c => reservation.performance.available_seats.tt = reservation.performance.available_seats.t and  rr.tt = rr.t
			}
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
}
pred upgradeClient[c: Client, e:EMAIL, t, tt : Time]{
	let cr = ClientsRegistered.clients{
		let cbanned = ClientsBanned.clients{ 
			c in cr.t //R6
			!(c in cbanned.t) //R6 
			all clients : cr.t | e != clients.email.t 
			c.email.tt = e 

			//Not changed
			cr.t - c = cr.tt - c
			c in cr.tt
			all cli : cr.tt | cli != c => cli.email.tt = cli.email.t
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

//================
// Operations - Theatre
//================

pred addTheatre[x: Theatre, t, tt: Time]{
	let tr = TheatresRegistered.theatres{
		!(x in tr.t) //R9
		(x.number_of_seats.t > 0)
		tr.tt = tr.t + x
		
		 x.number_of_seats.tt = x.number_of_seats.t 

		//Not changed
		all th : tr.t |  th.number_of_seats.tt = th.number_of_seats.t 
	}
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred updateTheatre[x: Theatre, n: Int, t, tt: Time]{
	let tr = TheatresRegistered.theatres {
		x in tr.t
		x.number_of_seats.tt = n
		tr.t - x = tr.tt - x
		x in tr.tt
		
		all performance :  PerformancesRegistered.performances.t| performance.theatre = x => performance.available_seats.tt = x.number_of_seats.t 

		//Not changed
		all th : tr.tt | th != x => th.number_of_seats.tt = th.number_of_seats.t
	}
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred removeTheatre[x: Theatre, t, tt: Time]{
	all p : PerformancesRegistered.performances.t | p.theatre != x  //R27
	let tr = TheatresRegistered.theatres {
		x in tr.t //R12
		tr.tt = tr.t - x

		//Not changed
		all th : tr.tt | th != x => th.number_of_seats.tt = th.number_of_seats.t 
	}

	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

//================
// Operations - Play
//================

pred addPlay[p: Play, t, tt: Time]{
	let pr = PlaysRegistered.plays{
		!(p in pr.t) //R13
		p.duration > 1
		pr.tt = pr.t + p	

	}
	unalteredTheatresRegistered [t, tt]
	unalteredClientsRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

//================
// Operations - Performance
//================

pred addPerformance[p: Performance, t, tt: Time]{
	let pr = PerformancesRegistered.performances{
		let playr = PlaysRegistered.plays{ 
			let tr = TheatresRegistered.theatres{ 	
				!(p in pr.t) //R15
				p.play in playr.t //R28
				p.theatre in tr.t //R29
				
				p.begin_time > 0
							
				add[p.begin_time, p.play.duration]  < p.end_time //R17
			    
				all performance : pr.t | !(performance.begin_time < p.end_time and p.begin_time < performance.end_time) //R19
			
				p.available_seats.tt = p.theatre.number_of_seats.t
			
				pr.tt = pr.t + p	
				
				//Not changed
				all performance : pr.tt | performance.available_seats.tt = performance.available_seats.t 
				all performance : pr.tt | performance.theatre.number_of_seats.tt = performance.theatre.number_of_seats.t
			}
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred cancelPerformance[p: Performance, t, tt: Time]{ //R18
	let pr = PerformancesRegistered.performances{
		let rr = ReservationsRegistered.reservations{		
			p in pr.t //R18
			pr.tt = pr.t - p
		
			all reservation : ReservationsRegistered.reservations.t | reservation.performance = p => reservation.performance.available_seats.tt =	add[reservation.performance.available_seats.t, reservation.num_reserved_seats.t] 
			rr.tt = rr.t - performance.p
			
			//Not changed
			all performance : pr.tt | performance != p => performance.available_seats.tt = performance.available_seats.t 
			all performance : pr.tt | performance.theatre.number_of_seats.tt = performance.theatre.number_of_seats.t 
			all reservation : ReservationsRegistered.reservations.t | reservation.performance != p => reservation.performance.available_seats.tt =	reservation.performance.available_seats.t
			rr.tt = rr.t
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

//================
// Operations - Reservations
//================

pred makeReservation[r: Reservation, t, tt: Time]{
	let rr = ReservationsRegistered.reservations {
		let cr = ClientsRegistered.clients {
			let pr = PerformancesRegistered.performances {
				let cbanned = ClientsBanned.clients{
					!(r in rr.t)
					!(r.client in cbanned.t)
					r.client in cr.t //R30
					r.performance in pr.t //R31				
				
					// all reservation : rr.t | r.performance = reservation.performance => sum[reservation.num_reserved_seats.t] < r.performance.available_seats.t //R25

					r.performance.available_seats.tt = sub[r.performance.available_seats.t, r.num_reserved_seats.t]
					rr.tt = rr.t + r
					
						
					all reservation : rr.tt | reservation.performance != r.performance =>  reservation.performance.available_seats.tt = reservation.performance.available_seats.t 
					all clients : ClientsRegistered.clients.tt | clients.email.tt = clients.email.t  
					all reservation : rr.tt | reservation != r => reservation.num_reserved_seats.tt = reservation.num_reserved_seats.t 
				}
			}
		}
	}
	unalteredTheatresRegistered [t, tt]
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred updateReservation[r: Reservation, n: Int, t,tt:Time]{
 	let rr = ReservationsRegistered.reservations{
		r in rr.t
		n > 0
		r.performance.available_seats.tt =sub[add[r.performance.available_seats.t, r.num_reserved_seats.t],n]
		r.num_reserved_seats.tt=n

		all reservation : rr.tt | reservation.performance != r.performance =>  reservation.performance.available_seats.tt = reservation.performance.available_seats.t 
		all reservation : rr.tt | reservation.client.email.tt = reservation.client.email.t
		all reservation : rr.tt | reservation != r => reservation.num_reserved_seats.tt = reservation.num_reserved_seats.t 
	}
	unalteredTheatresRegistered [t, tt]
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredReservationsRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}

pred cancelReservation[r: Reservation, t,tt:Time]{ //R22
 	let rr = ReservationsRegistered.reservations{
		r in rr.t
		r.performance.available_seats.tt =	add[r.performance.available_seats.t, r.num_reserved_seats.t] //R23
		rr.tt = rr.t - r

		all reservation : rr.tt | reservation.performance != r.performance =>  reservation.performance.available_seats.tt = reservation.performance.available_seats.t 
		all clients : ClientsRegistered.clients.tt | clients.email.tt = clients.email.t 
		all reservation : rr.tt | reservation != r => reservation.num_reserved_seats.tt = reservation.num_reserved_seats.t 
	}
	unalteredTheatresRegistered [t, tt]
	unalteredClientsRegistered [t, tt]
	unalteredPlaysRegistered [t, tt]
	unalteredPerformancesRegistered [t, tt]
	unalteredClientsBanned [t, tt]
}


//================
// Begin
//================

fact traces {
	init[first]
	all t: Time-last | let tt=t.next |
		some c: Client, th: Theatre, pl: Play, p: Performance, r: Reservation, e: EMAIL,  n: Int | 
			addClient[c, t, tt] or
			removeClient[c, t, tt] or
			banClient[c, t, tt]or
			upgradeClient[c, e, t, tt]or
			addTheatre[th, t,tt] or
			updateTheatre[th, n, t, tt] or
			removeTheatre[th, t, tt] or
			addPlay[pl, t, tt] or
			addPerformance[p, t, tt] or
			cancelPerformance[p, t, tt] or
			makeReservation[r, t, tt] or
			updateReservation[r, n, t, tt] or
			cancelReservation[r, t, tt] 
}

run addClient
run removeClient
run banClient
run addTheatre
run updateTheatre
run removeTheatre
run addPlay
run addPerformance for 4
run cancelPerformance for 4 
run makeReservation for 6
run updateReservation for 6
run cancelReservation for 6

//================
// Asserts
//================

//R1
assert everyClientMayRegister{
	all t: Time, c: Client, cr: ClientsRegistered.clients  | let tt = t.next | addClient[c, t, tt] => c in ClientsRegistered.clients.tt and c not in cr.t	 
}
check everyClientMayRegister for 10

//R2
assert everyClientHasNameAndEmail{
	all c:ClientsRegistered.clients.Time | c.name in NAME and c.email.Time in EMAIL
}
check everyClientHasNameAndEmail for 10

//R3
assert everyEmailIsUnique{   
	all t: Time, i, j: ClientsRegistered.clients.t | i.email = j.email => i = j
}
check everyEmailIsUnique for 10

//R4
assert onlyRegisteredClientsCanBeRemoved{   
	all t: Time, c : Client | let tt = t.next | removeClient[c,t,tt] => c not in ClientsRegistered.clients.tt
}
check onlyRegisteredClientsCanBeRemoved for 10

//R5
assert bannedClientsCantBeAdded{
	all t: Time, i: Client | let tt = t.next | banClient[i, t, tt] => !addClient[i, t, tt]
}
check bannedClientsCantBeAdded for 10

//R6	
assert intersectionBetweenBannedAndRegisteredIsEmpty{
	all t: Time, c1: ClientsRegistered.clients.t, c2: ClientsBanned.clients.t | c1!=c2 
}
check intersectionBetweenBannedAndRegisteredIsEmpty for 10

//R7
assert noClientsRegAtBeg{
	no ClientsRegistered.clients.first
}
check noClientsRegAtBeg for 10

//R8
assert noBannedClientsInTheBeggining{
	no ClientsBanned.clients.first
}
check noBannedClientsInTheBeggining for 10

//R9
assert everyTheatreMayRegister{
	all t: Time, th: Theatre, thr: TheatresRegistered.theatres  | let tt = t.next | addTheatre[th, t, tt] => th in TheatresRegistered.theatres.tt and th not in thr.t	 
}
check everyTheatreMayRegister for 10

//R10
assert theatresHaveNumberOfSeats{
	all t: Time, th: TheatresRegistered.theatres.t | #th.number_of_seats.t = 1
	all t: Time, th: Theatre | let tt = t.next | addTheatre[th, t, tt] => th.number_of_seats.t > 0
}
check theatresHaveNumberOfSeats for 10

//R11
assert noTheatresRegAtBeg{
	no TheatresRegistered.theatres.first
}
check noTheatresRegAtBeg for 10

//R12
assert removeOnlyRegTheatre {  
	all t: Time, th:Theatre| let tt = t.next | removeTheatre[th,t, tt] => th in TheatresRegistered.theatres.t
}
check removeOnlyRegTheatre for 10

//R13
assert everyPlayMayRegister{
	all t: Time, p: Play, pr: PlaysRegistered.plays  | let tt = t.next | addPlay[p, t, tt] => p in PlaysRegistered.plays.tt and p not in pr.t	 
}
check everyPlayMayRegister for 10

//R14
assert noPlayRegAtBeg{
	no PlaysRegistered.plays.first
}
check noPlayRegAtBeg for 10

//R15
assert everyPerformancesMayRegister{
	all t: Time, p: Performance, pr: PerformancesRegistered.performances  | let tt = t.next | addPerformance[p, t, tt] => p in PerformancesRegistered.performances.tt and p not in pr.t	 
}
check everyPerformancesMayRegister for 10

//R16
assert performanceHasIDPlayTheatreBeginEnd{
	all t: Time, p: Performance | p.play in PLAY and p.theatre in THEATRE and p.begin_time in Int and p.end_time in Int and p.available_seats.t in Int 
}
check performanceHasIDPlayTheatreBeginEnd for 10

//R17
assert performanceHasCorrectEndingTime{
	all t: Time, p: PerformancesRegistered.performances.t | add[p.begin_time, p.play.duration] < p.end_time
}
check performanceHasCorrectEndingTime for 10

//R18
assert performanceCanBeCancelled{
	all t: Time, p: PerformancesRegistered.performances.t | let tt = t.next | cancelPerformance[p, t, tt]  => p not in PerformancesRegistered.performances.tt
}
check performanceCanBeCancelled for 10

//R19 
assert twoPerformancesDontOverlap{
	all t: Time, p1: PerformancesRegistered.performances.t, p2: PerformancesRegistered.performances.t | p1 != p2 => !(p1.begin_time < p2.end_time and p2.begin_time < p1.end_time)
}
check twoPerformancesDontOverlap for 10

//R20
assert noPerformancesRegAtBeg{
	no PerformancesRegistered.performances.first
}
check noPerformancesRegAtBeg for 10

//R21
assert reservationHasIDClientNumSeatsPerformance{
	all t: Time, r: Reservation | r.client in CLIENT and r.num_reserved_seats.t in Int and r.performance in PERFORMANCE
}
check reservationHasIDClientNumSeatsPerformance for 10

//R22
assert reservationCanBeCancelled{
	all t: Time, r:  ReservationsRegistered.reservations.t | let tt = t.next | cancelReservation[r, t, tt]  => r not in ReservationsRegistered.reservations.tt
}
check reservationCanBeCancelled for 10

//R23
assert cancelReservationChangeAvailableSeats{
	all t: Time, r:  ReservationsRegistered.reservations.t | let tt = t.next | cancelReservation[r, t, tt]  =>  r.performance.available_seats.tt = add[r.performance.available_seats.t, r.num_reserved_seats.t]
}
check cancelReservationChangeAvailableSeats for 10

//R24
assert clientWithReservationCantBeRemove{
	all t: Time,  r: ReservationsRegistered.reservations.t| let tt = t.next | removeClient[r.client, t, tt] => r.client in ClientsRegistered.clients.tt
}
check clientWithReservationCantBeRemove for 10

//R25
assert numReservationCannotExceedCapacity{ 
	all t: Time, r: ReservationsRegistered.reservations.t, n: Int | let tt = t.next | updateTheatre[r.performance.theatre, n, t, tt]  => !makeReservation[r, t, tt]
}
check numReservationCannotExceedCapacity for 10

//R26
assert clientBannedNotHaveReservations{
	all t: Time, r: ReservationsRegistered.reservations.t | let tt = t.next | banClient[r.client, t, tt] => r not in ReservationsRegistered.reservations.tt 
}
check clientBannedNotHaveReservations for 10

//R27
assert theatreCannotBeRemoveIfHavePerformance{
	all t: Time, p: PerformancesRegistered.performances.t | let tt = t.next | removeTheatre[p.theatre, t, tt] => p.theatre in TheatresRegistered.theatres.tt 
}
check theatreCannotBeRemoveIfHavePerformance for 10

//R28
assert registeredPerformanceHaveOnlyTheatreRegistered{
	all t: Time, p: PerformancesRegistered.performances.t |  p.theatre in TheatresRegistered.theatres.t 
}
check registeredPerformanceHaveOnlyTheatreRegistered for 10

//R29
assert registeredPerformanceHaveOnlyPlaysRegistered{
	all t: Time, p: PerformancesRegistered.performances.t |  p.play in PlaysRegistered.plays.t 
}
check registeredPerformanceHaveOnlyPlaysRegistered for 10

//R30
assert registeredReservationsHaveOnlyClientsRegistered{
	all t: Time, r: ReservationsRegistered.reservations.t |  r.client in ClientsRegistered.clients.t 
}
check registeredReservationsHaveOnlyClientsRegistered for 10
 
//R31
assert registeredReservationsHaveOnlyPerformancesRegistered{
	all t: Time, r: ReservationsRegistered.reservations.t |  r.performance in PerformancesRegistered.performances.t 
}
check registeredReservationsHaveOnlyPerformancesRegistered for 10
