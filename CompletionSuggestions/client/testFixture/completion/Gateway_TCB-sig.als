abstract sig Host {
  trust: Trust
}

abstract sig ReferenceMonitor {
  capabilities: set Capabilities
}

abstract sig DP extends Host { }
abstract sig CP extends Host { }

sig Gateway extends DP {
  vswitch: set Vswitch,
  mbox: set Mbox,
  controller: one Controller,
  channel: Channel,
  channelProtection: Agent,
  hyp: lone Hypervisor
}

sig Vswitch, Mbox extends DP {
  SW: SWstate,
  SWprotection: Agent,
  pktsAccepted: Paths,
  pktProtection: Agent
} 

// set of trusted gateways for processing packets
sig TrustedDP in Gateway {}

sig Controller extends CP {
  policy: Policy,
  policyProtection: Agent, 
  channel: Channel,
  channelProtection: Agent,
  gateway: set Gateway,
  hyp: lone Hypervisor
}

sig Hypervisor extends ReferenceMonitor {
  agent: set Agent
}

abstract sig Agent {
 leverages: set Capabilities
}
sig PktSign, CommAgent, SecPolicy, vTPM extends Agent {}

abstract sig Pkt {
  processBy: set DP,
  action: one Action
}
// packets that either container attacks or were modified on data plane
sig MaliciousPkt extends Pkt { }
sig BenignPkt extends Pkt { }

abstract sig SWstate {}
one sig Attested, Vulnerable extends SWstate {}

abstract sig Paths {}
one sig Authenticated, Tagged, Original extends Paths {}

abstract sig Trust {}
one sig Trusted, NotTrusted extends Trust {}

abstract sig Policy {}
one sig Protected, Exposed extends Policy {}

abstract sig Channel {}
one sig AuthEncryp, Encrypted, Plaintext extends Channel {}

abstract sig Action {}
one sig Allow, Drop extends Action {}

abstract sig Capabilities {}
one sig Attestation, Isolation, Mediation extends Capabilities {}