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
  assigns: StateVar -> one Value  // mapping of state variables to new values
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
  s.DU + 
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
 * d.2: Ensures no asset is owned by two different users.
 */
fact UniqueOwnership {
  all disj a: AssetModel, u1, u2: DLTUser |
    a.owner = u1 implies u2 != u1
}

/**
 * d.3: Ensures each asset has at least one owner (non-empty).
 */
fact SomeOwner {
  all a: AssetModel | some a.owner
}

/**
 * d.4: Every asset's type is either Fungible or NonFungible.
 */
fact AssetPartition {
  all a: AssetModel | a.ttype = Fungible or a.ttype = NonFungible
}

/**
 * d.5: All distinct fungible assets must have equal unitVal.
 */
fact FungibleValueEquality {
  all disj a, b: AssetModel |
    a.ttype = Fungible && b.ttype = Fungible
      implies a.unitVal = b.unitVal
}

/**
 * d.6: All distinct non-fungible assets must have different unitVal.
 */
fact NonFungibleDistinct {
  all disj a, b: AssetModel |
    a.ttype = NonFungible && b.ttype = NonFungible
      implies a.unitVal != b.unitVal
}

/**
 * d.7: If c is the sum of two fungible assets a and b,
 * then c's value must be strictly greater than each summand.
 */
fact ValueOrdering {
  all a, b, c: AssetModel |
    a.ttype = Fungible && b.ttype = Fungible && c.ttype = Fungible &&
    a.unitVal + b.unitVal = c.unitVal
      implies a.unitVal < c.unitVal && b.unitVal < c.unitVal
}

/**
 * Ensures the hash-history graph is acyclic.
 */
fact AcyclicHistory {
  no h: Hash | h in h.^prev
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
 * In the initial state, there must be no predecessors or parents for the genesis block.
 */
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
 *      all ancestor transactions are included in the block's data.
 */
fact AppendOnlyLinear {
  all b: BlockRec |
    some b.prev implies ancestors[b].data in b.data
}

/**
 * g.8: Each block's Merkle root must be defined.
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
fact FullNodeSeesAll {
  all n: FullNode | n.sync = BlockId
}

/**
 * Light nodes see only a strict subset of blocks.
 */
fact LightNodePartial {
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
    5 Hash, 5 Payload, 5 Metadata, 5 StateVar, 5 Token,
    5 Service, 5 Asset,
    5 PublicKey, 5 PrivateKey, 5 KeyPair,
    5 Value, exactly 1 Zero, 5 PosValue

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
    5 Hash, 5 Payload, 5 Metadata, 5 StateVar, 5 Token,
    5 Service, 5 Asset,
    5 PublicKey, 5 PrivateKey, 5 KeyPair,
    5 Value, exactly 1 Zero, 5 PosValue
