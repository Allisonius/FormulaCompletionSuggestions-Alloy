// Automated Synthesis of Comprehensive Memory Model Litmus Test Suites
// Daniel Lustig, Andrew Wright, Alexandros Papakonstantinou, Olivier Giroux
// ASPLOS 2017
//
// Copyright (c) 2017, NVIDIA Corporation.  All rights reserved.
//
// This file is licensed under the BSD-3 license.  See LICENSE for details.

// Based on a model from Herding Cats [Alglave et al., TOPLAS 2014]

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// =Perturbations=

abstract sig PTag {} // Perturbation Tag
one sig RE extends PTag {} // Remove Event
one sig RD extends PTag {} // Remove Dep
one sig DFSC extends PTag {} // Demote Fence (SC for compatibility with the canonicalizer)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// =Basic model of memory=

sig Address { }

sig Thread { start: one Event }

abstract sig Event {
  po: lone Event
}

abstract sig MemoryEvent extends Event {
  address: one Address
}
sig Read extends MemoryEvent {
  rmw: lone Write,
  addr: set Event,
  ctrl: set Event,
  data: set Event
}
sig Write extends MemoryEvent {
  rf: set Read,
  co: set Write
}

abstract sig Fence extends Event { }
sig CtrlFence extends Fence {}
sig lwsync extends Fence {}
sig sync extends Fence {}
