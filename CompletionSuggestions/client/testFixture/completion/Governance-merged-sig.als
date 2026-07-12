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
