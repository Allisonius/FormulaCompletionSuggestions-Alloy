// Automated Synthesis of Comprehensive Memory Model Litmus Test Suites
// Daniel Lustig, Andrew Wright, Alexandros Papakonstantinou, Olivier Giroux
// ASPLOS 2017
//
// Copyright (c) 2017, NVIDIA Corporation.  All rights reserved.
//
// This file is licensed under the BSD-3 license.  See LICENSE for details.

// C11/C++11, based on a model from Batty et al. [POPL 2016]

////////////////////////////////////////////////////////////////////////////////
// =Perturbations=

abstract sig PTag {}
one sig RE extends PTag {}
one sig LS extends PTag {}
one sig DR extends PTag {}
one sig DA extends PTag {}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// =Model of memory=

sig Address { }

abstract sig MemoryOrder {}
one sig MemoryOrderNonAtomic extends MemoryOrder {}
one sig MemoryOrderRelaxed   extends MemoryOrder {}
one sig MemoryOrderAcquire   extends MemoryOrder {}
one sig MemoryOrderRelease   extends MemoryOrder {}
one sig MemoryOrderAcqRel    extends MemoryOrder {}
one sig MemoryOrderSeqCst    extends MemoryOrder {}

abstract sig Event {
  sb: set Event,
  memory_order: one MemoryOrder,
  sc: set Event
}
abstract sig MemoryEvent extends Event {
  address : one Address,
  rf: set Event,
  mo: set Event
}
sig Write extends MemoryEvent {}
sig Read extends MemoryEvent {}
sig RMW extends MemoryEvent {}
sig Fence extends Event {}
sig Thread { start: one Event }
