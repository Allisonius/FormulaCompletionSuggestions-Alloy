module checkmate

sig Core { }

abstract sig Process { }
one sig Attacker extends Process { }
one sig Victim extends Process { }

abstract sig Address { }

abstract sig Cacheability { }
one sig Cacheable extends Cacheability { }
lone sig NonCacheable extends Cacheability { }

sig CacheIndexL1 { }

sig VirtualAddress extends Address { 
	indexL1: one CacheIndexL1,
	map: one PhysicalAddress,
	cacheability: one Cacheability
}
                                
sig PhysicalAddress extends Address {
    readers: set Process,
    writers: set Process,
    region: one Process}

abstract sig Event {	
	po: lone Event,
	NodeRel: set Location,
	
	process: one Process,
	coh: set Event,
   	core: one Core,	

	sub_uhb: set Location->Event->Location,
	urf : set Location->Event->Location,		
	uco : set Location->Event->Location,
	ufr : set Location->Event->Location,
	ustb_flush: set Location->Event->Location,
	udep : set Location->Event->Location,
	uhb_spec : set Location->Event->Location,
	ucoh_inter : set Location->Event->Location,
	ucoh_intra : set Location->Event->Location,
	ustb: set Location->Event->Location,
	uvicl: set Location->Event->Location,		
  	ucci: set Location->Event->Location,
  	usquash: set Location->Event->Location,
  	ufence: set Location->Event->Location,
	uflush: set Location->Event->Location,	
	uhb_inter: set Location->Event->Location,
	uhb_intra: set Location->Event->Location,
	uhb_proc: set Location->Event->Location
}

abstract sig MemoryEvent extends Event {
	address: one VirtualAddress						
}

sig Read extends MemoryEvent {
    dep : set { MemoryEvent + CacheFlush }
}

sig Write extends MemoryEvent {
	rf: set Read,								
	co: set Write
}

abstract sig Fence extends Event { }
sig FenceSC extends Fence { 
	sc: set FenceSC
}

sig CacheFlush extends Event { 
    flush_addr : one VirtualAddress
}

sig Branch extends Event {
	outcome : one Outcome,
	prediction : one Outcome
}

abstract sig Outcome { }
one sig Taken extends Outcome { }
one sig NotTaken extends Outcome { }

abstract sig Location { }

sig Node {
	event: one Event,
	loc: one Location,
	uhb: set Node
}