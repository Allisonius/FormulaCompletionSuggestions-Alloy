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

// ── PeerNodes ────────────────────────────────────────────────────────────────

/**
 * f.1: FullNode and LightNode together cover all PeerNode instances.
 */
fact Partition {
  FullNode + LightNode = PeerNode
}

/**
 * Every PeerNode must have at least one role.
 */
fact RolesNonEmpty {
  all n: PeerNode | some n.roles
}

/**
 * Archive nodes must be full nodes (must store entire chain history).
 */
fact ArchiveOnlyFull {
  all n: PeerNode | Archive in n.roles implies n in FullNode
}

/**
 * No node is connected to itself.
 */
fact P2PIrreflexive {
  no n: PeerNode | n in n.peers
}

/**
 * Peer connections are bidirectional.
 */
fact P2PSymmetric {
  all n1, n2: PeerNode |
    n2 in n1.peers implies n1 in n2.peers
}

/**
 * Full nodes know every block in the network.
 */
fact FullSyncComplete {
  all n: FullNode | n.sync = BlockId
}

/**
 * Light nodes have only a strict subset of blocks.
 */
fact LightSyncPartial {
  all n: LightNode | n.sync != BlockId
}

/**
 * Capacities must be non-negative.
 */
fact NonNegativeCapacity {
  all n: PeerNode |
    n.storageCap >= 0 and n.bandwidthCap >= 0
}

/**
 * Full nodes are expected to have substantial storage.
 */
fact FullNodeHighStorage {
  all n: FullNode | n.storageCap > 1000
}

/**
 * Runs a small model to ensure the partitioning
 * and constraints can be satisfied.
 */
run {} for
    7 PeerNode,
    3 FullNode, 4 LightNode,
    10 BlockId,
    exactly 1 Validator, exactly 1 Miner, exactly 1 Archive, exactly 1 Observer,
    5 Int

// ── Wallet ───────────────────────────────────────────────────────────────────

fact KeyPairUniqueness {
  all k1, k2: KeyPair | k1 != k2 implies
    k1.publicKey  != k2.publicKey &&
    k1.privateKey != k2.privateKey
}

fact KeysAreUsed {
  all pk: PublicKey  | one kp: KeyPair | kp.publicKey  = pk
  all sk: PrivateKey | one kp: KeyPair | kp.privateKey = sk
}

/**
 * Returns the on-chain address derived from hashing the public key.
 */
fun addrOf(pub: PublicKey): one DLTAddress {
  pub.(AddrDerivation.hashes)
}

fact AccountLinkageAndAssets {
  all w: DLTUserWallet | {
    // c.6: link account identifier to the derived address
    w.account.identifiedBy = addrOf[w.kp.publicKey]
    // c.7: ensure the account has at least one asset
    some w.account.asset
  }
}

fact DistinctWalletAccounts {
  all w1, w2: DLTUserWallet | w1 != w2 implies
    w1.account != w2.account
}

fact MetaExistence {
  all w: DLTUserWallet | one m: WalletMeta | m.wallet = w
}

fact MetadataTotality {
  all m: WalletMeta |
    m.connType    in ConnType    &&
    m.custodyType in CustodyType
}

/**
 * Partition wallets into Hot vs. Cold sets.
 */
pred defineConnectivityPartitions {
  all m: WalletMeta |
    (m.connType = Hot  or m.connType = Cold)
}

/**
 * Partition wallets into Custodial vs. NonCustodial sets.
 */
pred defineCustodyPartitions {
  all m: WalletMeta |
    (m.custodyType = Custodial     or m.custodyType = NonCustodial)
}

run { defineConnectivityPartitions and defineCustodyPartitions } for
  5 DLTUserWallet, 5 WalletMeta,
  5 KeyPair, 5 PublicKey, 5 PrivateKey,
  5 DLTAccount, 5 Asset, 5 DLTAddress,
  5 AddrDerivation, 5 Time

// ── Asset ────────────────────────────────────────────────────────────────────

fact UniqueOwnership {
  all disj a: AssetModel, u1, u2: DLTUser |
    a.owner = u1 implies u2 != u1
}

fact SomeOwner {
  all a: AssetModel | some a.owner
}

fact AssetPartition {
  all a: AssetModel | a.ttype = Fungible or a.ttype = NonFungible
}

fact FungibleValueEquality {
  all disj a, b: AssetModel |
    a.ttype = Fungible && b.ttype = Fungible
      implies a.unitVal = b.unitVal
}

fact NonFungibleDistinct {
  all disj a, b: AssetModel |
    a.ttype = NonFungible && b.ttype = NonFungible
      implies a.unitVal != b.unitVal
}

/**
 * d.7: If c is the sum of two fungible assets a and b,
 * then c’s value must be strictly greater than each summand.
 */
fact ValueOrdering {
  all a, b, c: AssetModel |
    a.ttype = Fungible && b.ttype = Fungible && c.ttype = Fungible &&
    a.unitVal + b.unitVal = c.unitVal
      implies a.unitVal < c.unitVal && b.unitVal < c.unitVal
}

run {} for
  5 AssetModel,
  5 DLTUser,
  5 ExternalUser,
  5 State,
  exactly 1 First,
  exactly 1 Fungible,
  exactly 1 NonFungible,
  5 Int

// ── SmartContracts ───────────────────────────────────────────────────────────

/**
 * Oracle function for cross-chain contracts:
 * returns the set of values from a given source’s responses.
 */
fun oracle[c: CrossChain, src: OracleSource]: set OracleValue {
  src.requests.response
}

fact ProxyAcyclic {
  no c: SmartContract | c in c.proxy.^proxy
}

fact ProxyStateAlias {
  all c: SmartContract |
    some c.proxy implies c.state = c.proxy.state
}

fact ProxyCodeAlias {
  all c: SmartContract |
    some c.impl implies c.impl.code = c.code
}

fact DestructClearsState {
  all c: SmartContract | c.selfDestructed = True implies no c.state
}

fact RedeployFollowsDestruct {
  all c: SmartContract | some c.redeployedTo implies c.selfDestructed = True
}

fact RedeployFreshFields {
  all c: SmartContract |
    some c.redeployedTo implies
      c.redeployedTo.code != c.code &&
      no c.redeployedTo.state
}

fact OracleUsage {
  all c: SmartContract, os: OracleSource |
    os in c.usesOracle implies some os.requests
}

fact CrossChainOracle {
  all c: CrossChain | some src: OracleSource | src in c.usesOracle
}

fact ViewConsistency {
  all v: View |
    v.vals in v.sc.state
}

/**
 * Instantiate a small model to verify constraints.
 */
run {} for
  exactly 5 SmartContract, exactly 2 CrossChain,
  5 Bytecode, 5 StorageVar, 5 Value,
  3 OracleSource, 5 OracleRequest, 5 OracleValue,
  5 View,
  5 DLTUser, 5 ExternalUser,
  5 State, exactly 1 First

// ── Service ──────────────────────────────────────────────────────────────────

/**
 * requirement b.1:
 * Ensures service usage is Boolean: for any service, user, and time,
 * the timepoint is either included in usedBy[u] or not.
 */
assert ServiceUsageBoolean {
  all s: UsableService, u: DLTUser, t: Time |
    t in s.usedBy[u] or t not in s.usedBy[u]
}

// Run the check for a limited scope of model elements
check ServiceUsageBoolean for
  exactly 3 UsableService,
  exactly 2 DirectService,
  exactly 2 OutputService,
  exactly 2 ConsumedService,
  exactly 3 DLTUser,
  exactly 3 ExternalUser,
  exactly 3 Time,
  exactly 3 User,
  exactly 3 Service,
  exactly 3 Asset,
  exactly 3 DLTAccount,
  exactly 3 DLTAddress,
  exactly 3 KeyPair,
  exactly 3 PublicKey,
  exactly 3 PrivateKey,
  exactly 3 State,
  exactly 1 First,
  exactly 1 AddrDerivation

/**
 * requirement b.2:
 * DirectService and OutputService usages cannot overlap
 * for the same user at the same timepoint.
 */
fact DirectOutputNoOverlap {
  all ds: DirectService, os: OutputService, u: DLTUser, t: Time |
    t in ds.usedBy[u] implies t not in os.usedBy[u]
}

/**
 * requirement b.3:
 * A ConsumedService can be used by at most one user at any given timepoint.
 */
fact UniqueConsumedService {
  all cs: ConsumedService, u1, u2: DLTUser, t: Time |
    t in cs.usedBy[u1] and u1 != u2 implies t not in cs.usedBy[u2]
}

// ── Crypto ───────────────────────────────────────────────────────────────────

/**
 * f.2.1: Perfect correctness of symmetric encryption:
 * decrypting an encrypted message yields the original message.
 */
fact Symmetry {
  all se: SymEnc, sd: SymDec, k: SymKey, m: Message |
    sd.dec[k][ se.enc[k][m] ] = m
}

/**
 * f.2.2: Cipher injectivity:
 * under the same key, two different messages never map to the same cipher.
 */
fact NoCipherCollision {
  all se: SymEnc, k: SymKey, m1, m2: Message |
    se.enc[k][m1] = se.enc[k][m2] implies m1 = m2
}

/**
 * f.3: MAC totality:
 * every MAC algorithm must produce some hash for each (key, message) pair.
 */
fact MACTotal {
  all a: MACAlg, k: SymKey, m: Message |
    some a.mac[k][m]
}

/**
 * f.5.1: Signing correctness:
 * signing a hash under a keypair’s private key yields a signature
 * whose key and msg fields match the public key and input hash.
 */
fact SignCorrectness {
  all sa: SignAlg, kp: KeyPair, m: Message |
    let hval = RO.h[m],
        s    = sa.sign[kp.privateKey][hval] |
      s.msg = hval and s.key = kp.publicKey
}

/**
 * f.5.2: Signature uniqueness:
 * no two distinct Signature atoms carry the same (key, msg) pair.
 */
fact SignatureUniqueness {
  all disj s1, s2: Signature |
    s1.key = s2.key and s1.msg = s2.msg implies s1 = s2
}

/**
 * Combined assertion ensuring encryption, MACs, and signatures behave correctly.
 */
assert CryptoCoherence {
  // 6.1: Signing correctness
  all sa: SignAlg, kp: KeyPair, m: Message |
    let hval = RO.h[m],
        s    = sa.sign[kp.privateKey][hval] |
      s.key = kp.publicKey and s.msg = hval

  // 6.2: Encryption/decryption round-trip
  all se: SymEnc, sd: SymDec, k: SymKey, m: Message |
    sd.dec[k][ se.enc[k][m] ] = m

  // 6.3: MAC availability
  all ma: MACAlg, k: SymKey, m: Message |
    some ma.mac[k][m]
}

/**
 * Bounded check of the CryptoCoherence assertion.
 */
check CryptoCoherence for
  1 Message, 1 CryptoHash,
  3 SymKey, 3 Cipher,
  2 SymEnc, 2 SymDec,
  2 MACAlg,
  2 RO,
  2 SignAlg,
  3 Signature,
  3 DLTAccount, 3 DLTAddress, 3 AddrDerivation,
  3 Time,
  3 User, 3 Service, 3 Asset,
  exactly 3 PublicKey, 3 PrivateKey, 3 KeyPair

// ── Transaction ──────────────────────────────────────────────────────────────

/**
 * Ensures the hash-history graph is acyclic.
 */
fact AcyclicHistory {
  no h: TxHash | h in h.^prev
}

/**
 * e.2: Ensures each Transaction hash is unique.
 */
fact UniqueTransactionHashes {
  all t1, t2: Transaction |
    t1 != t2 implies t1.hash != t2.hash
}

/**
 * e.3: Payload must match the declared transaction type:
 * - Transfer transactions use TransferPayload.
// - Deploy/Invoke use ContractPayload.
 */
fact PayloadTypeConsistency {
  all t: Transaction |
    (t.tt = Transfer implies t.payload in TransferPayload) &&
    (t.tt != Transfer implies t.payload in ContractPayload)
}

/**
 * e.3: Transfers must carry a positive amount.
 */
fact PositiveAmounts {
  all tp: TransferPayload | tp.amount != Zero
}

/**
 * Instantiate a small model to validate all transaction constraints.
 */
run {} for
    5 Transaction,
    5 TransferPayload, 5 ContractPayload,
    5 TxHash, 5 Metadata,
    5 DLTUser, 5 Time, 5 State, exactly 1 First,
    5 AssetModel, 5 Token, 5 TxStateVar,
    5 TxValue, exactly 1 Zero, 5 PosValue,
    5 User,
    5 Service,
    5 Asset,
    5 DLTAccount,
    5 DLTAddress,
    5 PublicKey,
    5 PrivateKey,
    5 KeyPair,
    5 AddrDerivation,
    5 ExternalUser

// ── SoftwareClients ──────────────────────────────────────────────────────────

// h.1: Partition between wallet-based and node-based clients.
fact ClientPartition {
  WalletClient + NodeClient = Client
}

// Ensure wallet clients peer with at least one node.
fact WalletConnectivity {
  all w: WalletClient | some w.nodePeers
}

// Partition NodeClient into storage classes.
fact StoragePartition {
  LightClient + FullClient = NodeClient
}

// Every node client must have at least one protocol role.
fact RolesNonEmptyClient {
  all n: NodeClient | some n.roles
}

// Each node client must specify a vendor and a version.
fact VendorVersion {
  all n: NodeClient | some n.vendor and some n.version
}

/**
 * Node-client disk usage must always be positive.
 */
fact PositiveDisk {
  all n: NodeClient, t: Time | n.disk[t] > 0
}

/**
 * Node-client network bandwidth must always be positive.
 */
fact PositiveNetBW {
  all n: NodeClient, t: Time | n.netBW[t] > 0
}

/**
 * Full clients require substantial disk capacity.
 */
fact FullHasHighDisk {
  all n: FullClient, t: Time | n.disk[t] >= 1000
}

/**
 * Light clients have limited disk capacity.
 */
fact LightHasLowDisk {
  all n: LightClient, t: Time | n.disk[t] =< 100
}

/**
 * No client peers with itself.
 */
fact ClientP2PIrreflexive {
  no n: NodeClient | n in n.peers
}

/**
 * Peer connections are bidirectional.
 */
fact ClientP2PSymmetric {
  all n, m: NodeClient | m in n.peers implies n in m.peers
}

/**
 * Instantiate a small network of clients to validate constraints.
 */
run {} for
    5 Int,
    5 Client, 5 WalletClient, 5 NodeClient,
    3 FullClient, 2 LightClient,
    2 CRole, exactly 1 Execution, exactly 1 ClientConsensus,
    5 Time,
    4 Vendor, 5 Version,
    5 Service, 5 Asset,
    5 DLTAccount, 5 DLTAddress,
    5 PublicKey, 5 PrivateKey, 5 KeyPair, 5 AddrDerivation,
    5 DLTUserWallet, 5 DLTUser, 5 ExternalUser,
    5 State, exactly 1 First,
    5 WalletMeta

// ── Consensus ────────────────────────────────────────────────────────────────

/**
 * f.7: no non‐faulty node issues more than one proposal.
 */
fact UniqueProposal {
  all p1, p2: Proposal |
    p1.proposer = p2.proposer implies p1 = p2
}

/**
 * Each honest node must issue at least one proposal.
 */
fact ProposerActivity {
  all n: NonFaulty |
    some p: Proposal | p.proposer = n
}

/**
 * All proposals must use the same consensus value.
 */
fact UniformProposal {
  all p1, p2: Proposal |
    p1.v = p2.v
}

/**
 * No node makes more than one decision.
 */
fact UniqueDecisionPerNode {
  all d1, d2: Decision |
    d1.decider = d2.decider implies d1 = d2
}

/**
 * Decisions occur after that node’s own proposal.
 */
fact DecisionAfterProposal {
  all d: Decision |
    some p: Proposal |
      p.proposer = d.decider and d.t > p.t
}

/**
 * Every honest node eventually makes a decision.
 */
pred Termination {
  all n: NonFaulty |
    some d: Decision | d.decider = n
}

/**
 * Any decided value must have been proposed.
 */
pred Validity {
  all d: Decision |
    some p: Proposal | p.v = d.v
}

/**
 * No two decisions differ in value.
 */
pred Agreement {
  all d1, d2: Decision |
    d1.v = d2.v
}

/**
 * Combined consensus specification.
 */
assert ConsensusSpec {
  Termination and Validity and Agreement
}

check ConsensusSpec for
    exactly 1 NonFaulty,
    3 PeerNode,
    5 ConsValue,
    5 Proposal,
    5 Decision,
    10 Int,
    5 BlockId

// ── Ledger ───────────────────────────────────────────────────────────────────

/**
 * The unique genesis block with no predecessors or parents.
 */
one sig Genesis extends BlockRec {}
fact GenesisBase {
  no Genesis.prev
  no Genesis.parents
}

/**
 * g.2: Each non-genesis block is either a linear successor
 *      (one prev, no parents) or a DAG node (some parents, no prev).
 */
fact ChainOrDAG {
  all b: BlockRec - Genesis |
    (one b.prev and no b.parents) or
    (some b.parents and no b.prev)
}

/**
 * g.3: No cycles in the linear chain.
 */
fact LinearAcyclic {
  no b: BlockRec | b in b.^prev
}

/**
 * g.4: No cycles in the DAG of parent links.
 */
fact DAGAcyclic {
  no b: BlockRec | b in b.^parents
}

/**
 * g.5: All block identifiers are distinct.
 */
fact UniqueBlockIds {
  all disj b1, b2: BlockRec | b1.id != b2.id
}

/**
 * g.6: A transaction cannot appear in more than one block.
 */
fact TxUniqueness {
  no t: Transaction |
    some disj b1, b2: BlockRec | t in b1.data and t in b2.data
}

/**
 * Ancestor function for the linear chain.
 */
fun ancestors[b: BlockRec]: set BlockRec { b.^prev }

/**
 * g.7: Append-only property on linear chain:
 *      all ancestor transactions are included in the block’s data.
 */
fact AppendOnlyLinear {
  all b: BlockRec |
    some b.prev implies ancestors[b].data in b.data
}

/**
 * g.8: Each block’s Merkle root must be defined.
 */
fact RootWellFormed {
  all b: BlockRec | some b.meta.merkleRoot
}

/**
 * Height of a block in the linear chain: number of predecessors.
 */
fun height[b: BlockRec]: Int { #(b.^prev) }

/**
 * Heights increase by one along the linear chain.
 */
fact HeightMonotonic {
  all b: BlockRec | some b.prev implies height[b] = height[b.prev] + 1
}

/**
 * Full nodes see all blocks.
 */
fact FullNodeSeesAllBlocks {
  all n: FullNode | n.sync = BlockId
}

/**
 * Light nodes see only a strict subset of blocks.
 */
fact LightNodePartialBlocks {
  all n: LightNode | n.sync != BlockId
}

/**
 * Predicate to check a purely linear chain structure.
 */
pred linearChainOK {
  all b: BlockRec |
    (b = Genesis  => (no b.prev and no b.parents)) and
    (b != Genesis => (one b.prev and no b.parents))
}

/**
 * Check linearChainOK in a bounded scope.
 */
run linearChainOK for
    5 Int,
    5 BlockRec, 5 BlockMeta, 5 Transaction, 5 Time,
    5 DLTAddress, 5 DLTAccount, 5 AddrDerivation,
    5 BlockId,
    5 PeerNode, 3 FullNode, 4 LightNode,
    5 DLTUser, 5 ExternalUser, 5 State, exactly 1 First,
    5 TxHash, 5 Payload, 5 Metadata, 5 TxStateVar, 5 Token,
    5 Service, 5 Asset,
    5 PublicKey, 5 PrivateKey, 5 KeyPair,
    5 TxValue, exactly 1 Zero, 5 PosValue

/**
 * Predicate to check a DAG-based ledger (every non-genesis block has parents).
 */
pred dagLedgerOK {
  all b: BlockRec - Genesis | some b.parents
}

/**
 * Check dagLedgerOK in a bounded scope.
 */
run dagLedgerOK for
    5 Int,
    5 BlockRec, 5 BlockMeta, 5 Transaction, 5 Time,
    5 DLTAddress, 5 DLTAccount, 5 AddrDerivation,
    5 BlockId,
    5 PeerNode, 3 FullNode, 4 LightNode,
    5 DLTUser, 5 ExternalUser, 5 State, exactly 1 First,
    5 TxHash, 5 Payload, 5 Metadata, 5 TxStateVar, 5 Token,
    5 Service, 5 Asset,
    5 PublicKey, 5 PrivateKey, 5 KeyPair,
    5 TxValue, exactly 1 Zero, 5 PosValue

// ── Oracles ──────────────────────────────────────────────────────────────────

/**
 * Ensure a bijection between on‐chain requests and client metadata:
 * - every OracleRequest has exactly one ReqMeta
 * - every ReqMeta refers to exactly one OracleRequest
 */
fact ReqMetaBijection {
  all r: OracleRequest | one m: ReqMeta | m.req = r
  all m: ReqMeta       | one m.req
}

/**
 * Ensure a bijection between on‐chain values and off‐chain metadata:
 * - every OracleValue has exactly one ValMeta
 * - every ValMeta refers to exactly one OracleValue
 */
fact ValMetaBijection {
  all v: OracleValue | one m: ValMeta | m.val = v
  all m: ValMeta     | one m.val
}

/**
 * Link responses to their original requests:
 * the ValMeta.val must match the OracleRequest.response.
 */
fact ResponseMatchesRequest {
  all r: OracleRequest, mV: ValMeta |
    mV.val = r.response
}

/**
 * Enforce temporal ordering:
 * a response cannot arrive before its request was issued.
 */
fact ResponseAfterRequest {
  all mR: ReqMeta, mV: ValMeta |
    mV.val = mR.req.response implies mV.at >= mR.at
}

/**
 * Ensure every on‐chain request in each OracleSource
 * has corresponding client‐side metadata.
 */
assert OracleCoherent {
  all os: OracleSource |
    all r: os.requests |
      some m: ReqMeta | m.req = r
}

// Bounded check to validate the OracleCoherent assertion.
check OracleCoherent for
  10 Int,
  exactly 5 String,
  3 Bytecode, 3 StorageVar, 3 Value, 3 View,
  3 OracleSource, 3 OracleRequest, 3 OracleValue,
  3 ReqMeta, 3 ValMeta, 3 Client,
  3 SmartContract, 3 CrossChain,
  3 DLTAccount, 3 DLTAddress,
  3 PublicKey, 3 PrivateKey, 3 KeyPair,
  3 AddrDerivation, 3 Time,
  3 Service, 3 Asset,
  3 DLTUser, 3 ExternalUser,
  3 State, exactly 1 First,
  exactly 1 True, exactly 1 False,
  4 Vendor, exactly 1 Geth, exactly 1 Besu,
  exactly 1 Nethermind, exactly 1 Prysm,
  3 Version, 2 CRole,
  exactly 1 Execution, exactly 1 ClientConsensus,
  3 WalletClient, 3 NodeClient,
  3 LightClient, 3 FullClient,
  3 DLTUserWallet, 3 WalletMeta,
  2 ConnType, exactly 1 Hot, exactly 1 Cold,
  2 CustodyType, exactly 1 Custodial, exactly 1 NonCustodial

// ── Telemetry ────────────────────────────────────────────────────────────────

/**
 * Ensures each Latency entry links a proposal and decision on the same value.
 */
fact LatencyBinding {
  all l: Latency |
    l.prop.v = l.dec.v
}

/**
 * Service‐level objective: all observed latencies must be under 5000 ms.
 */
assert FiveSecondFinality {
  all l: Latency | l.ms < 5000
}

/**
 * Check the FiveSecondFinality assertion
 */
check FiveSecondFinality

/**
 * Collects all latency measurements.
 */
fun allLatencies: set Int {
  Latency.ms
}

/**
 * Computes the worst‐case latency.
 */
fun maxLatency: one Int {
  max[ allLatencies ]
}

/**
 * Computes the average latency (integer division).
 */
// fun avgLatency: one Int {
//   div[ sum[ allLatencies ], #Latency ]
// }

/**
 * Assert that the maximum observed latency stays below 8000 ms.
 */

/**
 * Assert that the maximum observed latency stays below 8000 ms.
 */
assert MaxLatencyBelowThreshold {
  maxLatency < 8000
}
check MaxLatencyBelowThreshold

/**
 * Assert that the average latency stays below 3000 ms.
 */
// assert AverageLatencyAcceptable {
//   avgLatency < 3000
// }
// check AverageLatencyAcceptable

/**
 * Predicate: once a proposal exists, its matching decision
 * must eventually occur.
 */
pred DecisionFollowsProposal[l: Latency] {
  always (l.prop in Proposal implies eventually (l.dec in Decision))
}

/**
 * Assert temporal consistency across latency entries.
 */

/**
 * Assert temporal consistency across latency entries.
 */
assert TemporalConsistency {
  all l: Latency | DecisionFollowsProposal[l]
}
check TemporalConsistency

// ── DLTSystem ────────────────────────────────────────────────────────────────

/**
 * Asserts that within any single block’s transaction set,
 * there are no two distinct TransferPayloads operating on the same token.
 */
assert NoDoubleSpend {
  no disj t1, t2: Transaction |
    // both transactions must be token transfers
    t1.payload in TransferPayload &&
    t2.payload in TransferPayload &&
    // they must reference the same token
    (t1.payload).token = (t2.payload).token &&
    // and both must appear together in some block
    some b: BlockRec | t1 in b.data && t2 in b.data
}

/**
 * Asserts that for every Decision made by a non‐faulty node,
 * the node’s sync set already contains at least one block identifier.
 */
assert DecisionImpliesLedgerTip {
  all d: Decision |
    let n = d.decider |
      some b: BlockRec | b.id in n.sync
}

/**
 * Asserts that any usage of a service by a user at time t
 * must be by a DLTUser in the initial state’s direct‐user set.
 */
assert OnlyDUInvokesService {
  all s: UsableService, u: DLTUser, t: Time |
    t in s.usedBy[u] implies u in First.DU
}

// Check no‐double‐spend in a small model with transfers and blocks
check NoDoubleSpend

// Check consensus/ledger agreement
check DecisionImpliesLedgerTip

// Check that only direct users invoke services
check OnlyDUInvokesService