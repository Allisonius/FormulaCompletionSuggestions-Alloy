package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class Checkmate {
	public static CompletionModelBuilder modelBuilder() {
		/*
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
		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("module checkmate")
				.withContent("")
				.withContent("sig Core { }")
				.withContent("")
				.withContent("abstract sig Process { }")
				.withContent("one sig Attacker extends Process { }")
				.withContent("one sig Victim extends Process { }")
				.withContent("")
				.withContent("abstract sig Address { }")
				.withContent("")
				.withContent("abstract sig Cacheability { }")
				.withContent("one sig Cacheable extends Cacheability { }")
				.withContent("lone sig NonCacheable extends Cacheability { }")
				.withContent("")
				.withContent("sig CacheIndexL1 { }")
				.withContent("").withContent("sig VirtualAddress extends Address { ")
				.withContent("    indexL1: one CacheIndexL1,")
				.withContent("    map: one PhysicalAddress,")
				.withContent("    cacheability: one Cacheability")
				.withContent("}")
				.withContent("                                 ")
				.withContent("sig PhysicalAddress extends Address {")
				.withContent("    readers: set Process,")
				.withContent("    writers: set Process,")
				.withContent("    region: one Process}")
				.withContent("").withContent("abstract sig Event {	")
				.withContent("    po: lone Event,")
				.withContent("    NodeRel: set Location,")
				.withContent("    ").withContent("    process: one Process,")
				.withContent("    coh: set Event,")
				.withContent("    core: one Core,	")
				.withContent("    ").withContent("    sub_uhb: set Location->Event->Location,")
				.withContent("    urf : set Location->Event->Location,		")
				.withContent("    uco : set Location->Event->Location,")
				.withContent("    ufr : set Location->Event->Location,")
				.withContent("    ustb_flush: set Location->Event->Location,")
				.withContent("    udep : set Location->Event->Location,")
				.withContent("    uhb_spec : set Location->Event->Location,")
				.withContent("    ucoh_inter : set Location->Event->Location,")
				.withContent("    ucoh_intra : set Location->Event->Location,")
				.withContent("    ustb: set Location->Event->Location,")
				.withContent("    uvicl: set Location->Event->Location,		")
				.withContent("    ucci: set Location->Event->Location,")
				.withContent("    usquash: set Location->Event->Location,")
				.withContent("    ufence: set Location->Event->Location,")
				.withContent("    uflush: set Location->Event->Location,	")
				.withContent("    uhb_inter: set Location->Event->Location,")
				.withContent("    uhb_intra: set Location->Event->Location,")
				.withContent("    uhb_proc: set Location->Event->Location")
				.withContent("}")
				.withContent("").withContent("abstract sig MemoryEvent extends Event {")
				.withContent("    address: one VirtualAddress						")
				.withContent("}")
				.withContent("").withContent("sig Read extends MemoryEvent {")
				.withContent("    dep : set { MemoryEvent + CacheFlush }")
				.withContent("}")
				.withContent("").withContent("sig Write extends MemoryEvent {")
				.withContent("    rf: set Read,								")
				.withContent("    co: set Write")
				.withContent("}")
				.withContent("").withContent("abstract sig Fence extends Event { }")
				.withContent("sig FenceSC extends Fence { ")
				.withContent("    sc: set FenceSC")
				.withContent("}")
				.withContent("").withContent("sig CacheFlush extends Event { ")
				.withContent("    flush_addr : one VirtualAddress")
				.withContent("}")
				.withContent("").withContent("sig Branch extends Event {")
				.withContent("    outcome : one Outcome,")
				.withContent("    prediction : one Outcome")
				.withContent("}")
				.withContent("").withContent("abstract sig Outcome { }")
				.withContent("one sig Taken extends Outcome { }")
				.withContent("one sig NotTaken extends Outcome { }")
				.withContent("").withContent("abstract sig Location { }")
				.withContent("").withContent("sig Node {")
				.withContent("    event: one Event,")
				.withContent("    loc: one Location,")
				.withContent("    uhb: set Node")
				.withContent("}");
		return builder;
	}
}
