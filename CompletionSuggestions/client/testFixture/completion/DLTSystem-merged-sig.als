// Merged model: DLTSystem.als with inlined dependencies
// Sources: DLTTypes.als, User.als, PeerNodes.als, Wallet.als, Asset.als,
//          SmartContracts.als, Service.als, Crypto.als, Transaction.als,
//          SoftwareClients.als, Consensus.als, Ledger.als, Oracles.als,
//          Telemetry.als
// See DEPENDENCIES.md for the full dependency graph and merge order.

open util/integer
open util/boolean

// ── DLTTypes ─────────────────────────────────────────────────────────────────


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

// ── User ─────────────────────────────────────────────────────────────────────

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
 * Associates a ledger user with exactly one keypair and one on-chain account.
 */
sig DLTUserWallet {
  owner   : one DLTUser,    // who controls this wallet
  kp      : one KeyPair,    // exactly one cryptographic keypair per wallet
  account : one DLTAccount  // exactly one on-chain account per wallet
}

/**
 * Metadata classifying each wallet by connectivity and custody.
 */
sig WalletMeta {
  wallet      : one DLTUserWallet,  // the wallet being described
  connType    : one ConnType,       // c.9: Hot vs. Cold connectivity
  custodyType : one CustodyType     // c.10: Custodial vs. Non-Custodial
}



abstract sig ConnType {}             // supertype for connection categories
one sig Hot, Cold extends ConnType {}  // online vs. offline wallets



abstract sig CustodyType {}            // supertype for custody categories
one sig Custodial, NonCustodial extends CustodyType {}  // third-party vs. self-custody

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

// d.4: fungible vs. non-fungible type hierarchy
abstract sig TokenType {}
one sig Fungible, NonFungible extends TokenType {}  // d.4

/**
 * On-chain smart contract bytecode representation.
 */
sig Bytecode {}

/**
 * Identifiers for individual storage slots in a contract.
 */
sig StorageVar {}

/**
 * Generic values stored or computed by contracts.
 */
sig Value {}

/**
 * External oracle data source, with a set of pending requests.
 */
sig OracleSource {
  requests: set OracleRequest  // outstanding oracle queries
}

/**
 * An oracle query request, yielding a response value.
 */
sig OracleRequest {
  response: one OracleValue    // the value provided by the oracle
}

/**
 * The possible values returned by an oracle.
 */
sig OracleValue {}

/**
 * Confidentiality view exposing a subset of a contract’s state
 * to a particular DLTUser.
 */
sig View {
  user : one DLTUser,                          // the viewer
  sc   : one SmartContract,                    // contract being viewed
  vals : StorageVar -> lone Value              // storage entries visible to user
}

/**
 * Cross-chain contract subtype, supporting oracle calls.
 */
sig CrossChain extends SmartContract {}

/**
 * Core smart contract signature.
 * - code: its deployed bytecode.
// - state: mapping from storage variables to stored values.
// - proxy/impl: upgrade-pattern pointers.
// - selfDestructed: indicates if contract has been destroyed.
// - redeployedTo: points to successor after self-destruct.
// - usesOracle: which external sources it may query.
 */
sig SmartContract {
  code           : one Bytecode,
  state          : StorageVar -> lone Value,
  proxy          : lone SmartContract,
  impl           : lone SmartContract,
  selfDestructed : one Bool,
  redeployedTo   : lone SmartContract,
  usesOracle     : set OracleSource
}

/**
 * Abstract service that can be used by DLTUsers over time.
 * Maps each DLTUser to the set of Timepoints when they use the service.
 */
abstract sig UsableService {
  usedBy: DLTUser -> set Time
}

/**
 * Concrete service types extending UsableService:
 * - DirectService: services invoked directly by users.
 * - OutputService: services that produce outputs for users.
 * - ConsumedService: services whose usage consumes a resource exclusively.
 */
abstract sig DirectService, OutputService, ConsumedService extends UsableService {}

/**
 * Abstract representation of a message (e.g., a byte sequence).
 */
sig Message {}

/**
 * Placeholder for a 256-bit digest produced by hash or MAC functions.
 */
sig CryptoHash {}

/**
 * Shared symmetric key for encryption/decryption.
 */
sig SymKey {}

/**
 * Ciphertext produced by symmetric encryption.
 */
sig Cipher {}

/**
 * Symmetric encryption algorithm:
 * enc[k][m] returns the ciphertext of message m under key k.
 */
sig SymEnc {
  enc: SymKey -> Message -> one Cipher
}

/**
 * Symmetric decryption algorithm:
 * dec[k][c] returns the plaintext message from ciphertext c under key k.
 */
sig SymDec {
  dec: SymKey -> Cipher -> one Message
}

/**
 * Abstract MAC algorithm:
 * mac[k][m] produces a hash tag authenticating message m under key k.
 */
sig MACAlg {
  mac: SymKey -> Message -> one CryptoHash
}

/**
 * Random-oracle abstraction:
 * h[m] returns a unique hash for message m.
 */
sig RO {
  h: Message -> one CryptoHash
}

/**
 * Injectivity constraint lifted from RO's appended sig-fact block.
 */
fact RO_facts {
  all r: RO | {
    // Enforce injectivity within the finite model
      all disj m1, m2: Message | r.h[m1] = r.h[m2] implies m1 = m2
  }
}

/**
 * A digital signature, binding a message hash to a public key.
 */
sig Signature {
  msg : one CryptoHash,  // the hashed message being signed
  key : one PublicKey    // the public key corresponding to the signer
}

/**
 * Abstract signature algorithm:
 * sign[sk][h] produces a signature under private key sk on hash h.
 */
sig SignAlg {
  sign: PrivateKey -> CryptoHash -> one Signature
}

/**
 * A transferable token on-chain, reusing the AssetModel signature.
 */
sig Token extends AssetModel {}

/**
 * Identifiers for smart contract state variables.
 */
sig TxStateVar {}

/**
 * Transaction kinds: transfer of tokens, deploy of contracts, or invoke of existing contracts.
 */

/**
 * Transaction kinds: transfer of tokens, deploy of contracts, or invoke of existing contracts.
 */
abstract sig TxType {}
one sig Transfer, Deploy, Invoke extends TxType {}

/**
 * Value kinds carried by transactions.
 * - Zero: represents a zero amount.
// - PosValue: strictly positive amounts.
 */

/**
 * Value kinds carried by transactions.
 * - Zero: represents a zero amount.
// - PosValue: strictly positive amounts.
 */
abstract sig TxValue {}

/**
 * Value kinds carried by transactions.
 * - Zero: represents a zero amount.
// - PosValue: strictly positive amounts.
 */
one sig Zero extends TxValue {}
sig PosValue extends TxValue {}

/**
 * Cryptographic hash linking transactions in a history DAG.
 */
sig TxHash {
  prev: set TxHash   // predecessor hashes
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
  amount          : one TxValue   // must be non-zero for valid transfers
}

/**
 * Payload for contract operations (deploy or invoke).
 */
sig ContractPayload extends Payload {
  assigns: TxStateVar -> one TxValue  // mapping of state variables to new values
}

/**
 * Opaque metadata container attached to each transaction.
 */
sig Metadata {}

/**
 * On-chain transaction record.
 */
sig Transaction {
  hash    : one TxHash,     // unique identifier
  tt      : one TxType,     // transaction type
  payload : one Payload,    // associated payload
  meta    : one Metadata    // auxiliary metadata
}

/**
 * Abstract superclass for all software clients interacting with the network.
 */
abstract sig Client {}

/**
 * Clients that act on behalf of end-users via wallets.
 * - wallet: the on-chain wallet they control.
// - nodePeers: the set of node-clients they connect to.
 */
sig WalletClient extends Client {
  wallet    : one DLTUserWallet,
  nodePeers : set NodeClient
}

/**
 * Clients that run full node software.
// - roles: protocol roles (execution and/or consensus).
// - disk: storage capacity (TB) as a function of time.
// - netBW: network bandwidth (GB/s) as a function of time.
// - peers: P2P connections to other node-clients.
// - vendor: software vendor implementation.
// - version: software version identifier.
 */
abstract sig NodeClient extends Client {
  roles    : set CRole,
  disk     : Time -> one Int,
  netBW    : Time -> one Int,
  peers    : set NodeClient,
  vendor   : one Vendor,
  version  : one Version
}

/**
 * Light‐weight node clients with limited storage.
 */
sig LightClient, FullClient extends NodeClient {}

/**
 * Protocol roles that a node client may perform.
 */

/**
 * Protocol roles that a node client may perform.
 */
abstract sig CRole {}
one sig Execution, ClientConsensus extends CRole {}

/**
 * Software vendors providing node-client implementations.
 */

/**
 * Software vendors providing node-client implementations.
 */
abstract sig Vendor {}
one sig Geth, Besu, Nethermind, Prysm extends Vendor {}

/**
 * Version identifiers for node-client software.
 */
sig Version {}

/**
 * Values over which peers must reach agreement.
 */
sig ConsValue {}

// We model time directly as Int timestamps.

/**
 * The subset of nodes assumed honest (non‐faulty).
 */
one sig NonFaulty extends PeerNode {}

/**
 * A proposal by a non‐faulty node (proposer) for value v at time t.
 */
sig Proposal {
  proposer: one NonFaulty,  // only non‐faulty nodes may propose
  v:        one ConsValue,  // proposed consensus value
  t:        one Int         // proposal timestamp
}

/**
 * A decision by a non‐faulty node (decider) on value v at time t.
 */
sig Decision {
  decider: one NonFaulty,   // node making the decision
  v:       one ConsValue,   // decided value
  t:       one Int          // decision timestamp
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
 * - meta: the block’s metadata.
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

/**
 * Metadata for an on‐chain oracle request, recording:
 * - req: the on‐chain OracleRequest
 * - issuer: which off‐chain Client issued it
 * - at: timestamp of issuance
 * - query: the query string payload
 */
sig ReqMeta {
  req    : one OracleRequest,
  issuer : one Client,
  at     : one Int,
  query  : one String
}

/**
 * Metadata for an on‐chain oracle response, recording:
 * - val: the on‐chain OracleValue
 * - at: timestamp of arrival
 * - data: the returned data string
 */
sig ValMeta {
  val  : one OracleValue,
  at   : one Int,
  data : one String
}

/**
 * Captures the latency between a proposal and its corresponding decision.
 * - prop: the Proposal instance
 * - dec:  the matching Decision instance
 * - ms:   the observed latency in milliseconds
 */
sig Latency {
  prop : one Proposal,
  dec  : one Decision,
  ms   : one Int
}