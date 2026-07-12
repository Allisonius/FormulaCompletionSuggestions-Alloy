// Merged model: Ledger.als with inlined dependencies
// (DLTTypes.als, User.als, PeerNodes.als, Asset.als, Transaction.als)

open util/integer    // for Int, +, >=

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
 * Unique identifiers for blockchain blocks.
 */
sig BlockId {}

/**
 * Roles that a peer node can hold in the network.
 * - Validator: participates in consensus validations.
// - Miner: creates new blocks.
// - Archive: stores full chain history.
// - Observer: lightweight monitoring node.
 */
abstract sig Role {}
one sig Validator, Miner, Archive, Observer extends Role {}

/**
 * Represents a node in the peer‐to‐peer network.
 * - roles: set of roles this node fulfills (requirement f.2).
 * - peers: its direct P2P connections (requirement f.3).
 * - sync:  the set of blocks it knows about (f.4–f.5).
 * - storageCap: its disk/storage capacity (added realism).
 * - bandwidthCap: its network bandwidth capacity (added realism).
 */
sig PeerNode {
  roles:        set Role,
  peers:        set PeerNode,
  sync:         set BlockId,
  storageCap:   one Int,
  bandwidthCap: one Int
}

/**
 * Two concrete partitions of PeerNode:
 * - FullNode: maintains full chain state.
// - LightNode: only partial sync.
 */
sig FullNode, LightNode extends PeerNode {}

/**
 * On-chain asset, owned by exactly one DLTUser,
 * classified by a TokenType, and carrying an integer value.
 */
sig AssetModel extends Asset {
  owner   : one DLTUser,  // d.1: exactly one owner per asset
  ttype   : one TokenType,
  unitVal : one Int       // numeric value from V_asset
}

// d.4: fungible vs. non-fungible type hierarchy
abstract sig TokenType {}
one sig Fungible, NonFungible extends TokenType {}  // d.4

/**
 * A transferable token on-chain, reusing the AssetModel signature.
 */
sig Token extends AssetModel {}

/**
 * Identifiers for smart contract state variables.
 */
sig StateVar {}

/**
 * Transaction kinds: transfer of tokens, deploy of contracts, or invoke of existing contracts.
 */
abstract sig Type {}
one sig Transfer, Deploy, Invoke extends Type {}

/**
 * Value kinds carried by transactions.
 * - Zero: represents a zero amount.
// - PosValue: strictly positive amounts.
 */
abstract sig Value {}
one sig Zero extends Value {}
sig PosValue extends Value {}

/**
 * Cryptographic hash linking transactions in a history DAG.
 */
sig Hash {
  prev: set Hash   // predecessor hashes
}

/**
 * Abstract payload for transactions.
 */
abstract sig Payload {}

/**
 * Payload for token transfers.
 */
sig TransferPayload extends Payload {
  sender, receiver: one DLTUser,  // participants
  token           : one Token,    // token being transferred
  atTime          : one Time,     // timestamp of transfer
  amount          : one Value     // must be non-zero for valid transfers
}

/**
 * Payload for contract operations (deploy or invoke).
 */
sig ContractPayload extends Payload {
  assigns: StateVar -> 
}

/**
 * Opaque metadata container attached to each transaction.
 */
sig Metadata {}

/**
 * On-chain transaction record.
 */
sig Transaction {
  hash    : one Hash,       // unique identifier
  tt      : one Type,       // transaction type
  payload : one Payload,    // associated payload
  meta    : one Metadata    // auxiliary metadata
}

/**
 * Metadata attached to each block.
 * - timestamp: when the block was created.
 * - nonce: consensus-generated number.
 * - merkleRoot: authenticated-data-structure root (e.g., Merkle Patricia root).
 */
sig BlockMeta {
  timestamp : one Time,
  nonce     : one Int,
  merkleRoot: one DLTAddress
}

/**
 * A block record in the ledger.
 * - id: unique identifier for the block.
 * - data: the set of transactions included.
 * - prev: predecessor in a linear chain (at most one).
 * - parents: parent set in a DAG view (zero or more).
 * - meta: the block's metadata.
 */
sig BlockRec {
  id      : one BlockId,
  data    : set Transaction,
  prev    : lone BlockRec,
  parents : set BlockRec,
  meta    : one BlockMeta
}

/**
 * The unique genesis block with no predecessors or parents.
 */
one sig Genesis extends BlockRec {}
