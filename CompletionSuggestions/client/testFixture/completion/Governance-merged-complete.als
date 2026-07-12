// Merged model: Governance.als with inlined dependencies (DLTTypes.als, User.als)

open util/integer       // for Int, #, ≥, ≤, sum

/**
 * Abstract representation of any actor on the ledger,
 * whether a human user or an automated system component.
 */
abstract sig User {}

/**
 * Abstract notion of a service interacting with the ledger,
 * e.g., an exchange, oracle, or identity provider.
 */
abstract sig Service {}

/**
 * Anything of value tracked on-chain, whether fungible tokens
 * or unique non-fungible items.
 */
abstract sig Asset {}

/**
 * On-chain account holding assets and identified by an address.
 */
sig DLTAccount {
  asset       : set Asset,         // the set of assets owned by this account
  identifiedBy: lone DLTAddress    // optional address identifying this account
}

/**
 * Blockchain address, typically a 160-bit value in real systems.
 */
sig DLTAddress {}

/**
 * Public key used to verify signatures.
 */
sig PublicKey {}

/**
 * Private key used to create signatures.
 */
sig PrivateKey {}

/**
 * Associates a public key with its corresponding private key.
 */
sig KeyPair {
  publicKey : one PublicKey,     // the public half of the keypair
  privateKey: one PrivateKey     // the private half of the keypair
}

/**
 * Mapping from each PublicKey to the on-chain address
 * derived via its hash function.
 */
sig AddrDerivation {
  hashes: PublicKey -> one DLTAddress   // function: pubKey ↦ address
}

/**
 * Abstract timepoint, for timestamping or ordering events.
 */
sig Time {}

/**
 * On-chain user roles.
 * - DLTUser: participants with ledger accounts.
// - ExternalUser: users outside the ledger context.
 */
sig DLTUser, ExternalUser extends User {}

/**
 * Represents a snapshot of the system at a point in time.
 */
sig State {
  next: lone State,        // optional pointer to the next state
  DU:   set DLTUser,       // users already added to on-chain (Direct Users)
  EU:   set ExternalUser   // users yet to be added (External Users)
}

/**
 * The initial state of the system; there is exactly one.
 */
one sig First extends State {}

/**
 * The off‐chain committee responsible for governance.
 * Contains one or more DLTUsers as members.
 */
one sig GovCommittee {
  members: some DLTUser    // committee membership set (non‐empty)
}

/**
 * Enumeration of possible proposal states.
 */
abstract sig ProposalState {}
one sig Pending, Active, Passed, Rejected, Executed extends ProposalState {}

/**
 * Whether a proposal's voting is open to all or restricted.
 */
abstract sig Participation {}
sig Public, Private extends Participation {}

/**
 * Governance proposal record:
 * - id: unique integer identifier
 * - proposer: DLTUser who created it (must be authorized)
 * - createdAt: timestamp of creation
 * - votingStart: timestamp when voting opens
 * - votingEnd: timestamp when voting closes
 * - participation: Public or Private voting
 * - state: current lifecycle state (Pending initially)
 */
sig Proposal {
  id            : one Int,
  proposer      : one DLTUser,
  createdAt     : one Int,
  votingStart   : one Int,
  votingEnd     : one Int,
  participation : one Participation,
  var state     : one ProposalState
}

/**
 * Possible vote choices.
 */
abstract sig VoteChoice {}
sig For, Against, Abstain extends VoteChoice {}

/**
 * A vote cast by a DLTUser on a proposal:
 * - voter: the user casting the vote
 * - proposal: the target proposal
 * - choice: For, Against, or Abstain
 * - at: timestamp of the vote
 */
sig Vote {
  voter    : one DLTUser,
  proposal : one Proposal,
  choice   : one VoteChoice,
  at       : one Int
}

/**
 * Governance parameters including required quorum.
 */
one sig GovParams {
  quorum: one Int   // minimum number of votes needed
}

/**
 * In the initial state, there must be no successor.
 */
fact {
  no First.next
}

/**
 * requirement a.1:
 * Initially, there must be at least one external user.
 */
fact {
  some First.EU
}

/**
 * requirement a.2:
 * At any state, ExternalUser and DLTUser sets are disjoint.
 */
fact {
  all u: User, s: State |
    u in s.EU implies u not in s.DU
}

/**
 * requirement a.3:
 * At any state, every User is either external or direct.
 */
fact {
  all s: State |
    s.DU + s.EU = User
}

/**
 * requirement a.4:
 * Transition that moves an ExternalUser r from EU to DU.
 *
 * @param r   the ExternalUser to add
 * @param s   the current state
 * @param s2  the next state after adding r
 */
pred addUser[r: ExternalUser, s, s2: State] {
  s.next = s2               // link current state to next
  r in s.EU                  // r must be external in s
  s2.DU = s.DU + r           // add r to direct-user set
  s2.EU = s.EU - r           // remove r from external-user set
}

/**
 * Combined invariant to check at any state.
 * - There is at least one ExternalUser.
// - Disjointness of EU and DU.
// - Partition covers all Users.
 */
pred InvariantPhi[s: State] {
  some s.EU
  all u: User | u in s.EU implies u not in s.DU
  s.DU + s.EU = User
}

/**
 * Assert that executing addUser preserves the invariant.
 */
assert AddPreservesInvariant {
  all r: ExternalUser, s, s2: State |
    InvariantPhi[s] and addUser[r, s, s2]
    implies InvariantPhi[s2]
}

/**
 * Check the preservation assertion.
 */
check AddPreservesInvariant for 5

/**
 * Predicate to check whether a user is authorized
 * (i.e., is a committee member).
 */
pred isAuthorized[u: DLTUser] {
  u in GovCommittee.members
}

/**
 * Only committee members may create proposals.
 */
fact OnlyAuthorizedProposers {
  all p: Proposal | p.proposer in GovCommittee.members
}

/**
 * Timestamps must satisfy:
 * createdAt ≤ votingStart < votingEnd.
 */
fact ProposalTimestamps {
  all p: Proposal | p.createdAt =< p.votingStart and p.votingStart < p.votingEnd
}

/**
 * Every new proposal begins in the Pending state.
 */
fact InitialProposalState {
  all p: Proposal | p.state = Pending
}

/**
 * Each member may vote at most once per proposal.
 */
fact OneVotePerMember {
  all v1, v2: Vote |
    v1.voter = v2.voter && v1.proposal = v2.proposal implies v1 = v2
}

/**
 * Votes must occur within the proposal's voting window.
 */
fact VoteWithinWindow {
  all v: Vote | v.at >= v.proposal.votingStart and v.at =< v.proposal.votingEnd
}

/**
 * If voting is private, only committee members may vote.
 */
fact PrivateVotingOnlyCommittee {
  all v: Vote |
    v.proposal.participation = Private implies
      v.voter in GovCommittee.members
}

/**
 * Helper: votes of type For on a proposal.
 */
fun votesFor[p: Proposal]:     set Vote { For.~choice & p.~proposal }

/**
 * Helper: votes of type Against on a proposal.
 */
fun votesAgainst[p: Proposal]: set Vote { Against.~choice & p.~proposal }

/**
 * Helper: votes of type Abstain on a proposal.
 */
fun votesAbstain[p: Proposal]: set Vote { Abstain.~choice & p.~proposal }

/**
 * Total votes cast on a proposal.
 */
fun totalVotes[p: Proposal]: set Vote {
  votesFor[p] + votesAgainst[p] + votesAbstain[p]
}

/**
 * Quorum must be at least 1.
 */
fact QuorumPositive {
  GovParams.quorum >= 1
}

/**
 * If quorum reached and For ≥ Against, proposal passes.
 */
fact DeterminePass {
  all p: Proposal |
    (some params: GovParams |
       #totalVotes[p] >= params.quorum &&
       #votesFor[p]   >= #votesAgainst[p])
    implies p.state = Passed
}

/**
 * If quorum reached and For < Against, proposal is rejected.
 */
fact DetermineReject {
  all p: Proposal |
    (some params: GovParams |
       #totalVotes[p] >= params.quorum &&
       #votesFor[p]   <  #votesAgainst[p])
    implies p.state = Rejected
}

/**
 * A proposal may only be executed if it has passed.
 */
fact ExecutionRules {
  all p: Proposal |
    p.state = Executed implies p.state = Passed
}

/**
 * Transition to execute a proposal.
 */
pred execute[p: Proposal] {
  p.state = Passed
  // optionally: set p.state' = Executed in next state
}

/**
 * Lifecycle progression:
 * - Pending until Active.
// - Active until Passed or Rejected.
 */
fact StateProgression {
  always (all p: Proposal |
    (p.state = Pending) until (p.state = Active) and
    (p.state = Active) until (p.state = Passed or p.state = Rejected)
  )
}

/**
 * Every proposal eventually becomes Active.
 */
fact EventualActivation {
  always (all p: Proposal |
    eventually (p.state = Active)
  )
}

/**
 * Instantiate a small governance trace to validate properties.
 */
run {}
