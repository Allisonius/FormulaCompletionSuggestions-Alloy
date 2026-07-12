open util/ordering[netState]

sig value{succ: set value, pre: set value}
one sig zero extends value{}
fact zero_facts { all z : zero | no z.pre }
one sig maxx extends value{}
fact maxx_facts { all mx : maxx | no mx.succ }
one sig valOne extends value{}
fact valOne_facts { all v : valOne | v.pre = zero }
one sig valTwo extends value{}
fact valTwo_facts { all v : valTwo | v.pre = (zero+valOne) }
one sig valThree extends value{}
fact valThree_facts { all v : valThree | v.pre = (zero+valOne+valTwo) }
one sig valFour extends value{}
fact valFour_facts { all v : valFour | v.pre = (zero+valOne+valTwo+valThree) }
one sig valFive extends value{}
fact valFive_facts { all v : valFive | v.pre = (zero+valOne+valTwo+valThree+valFour) }
one sig valSix extends value{}
fact valSix_facts { all v : valSix | v.pre = (zero+valOne+valTwo+valThree+valFour+valFive) }

abstract sig utility{}
one sig utility_submodular extends utility{}
one sig utility_non_submodular extends utility{}

abstract sig release_outbid{}
one sig release_outbid_yes extends release_outbid{}
one sig release_outbid_no extends release_outbid{}

one sig NULL{}

sig pnode{
	pcp: one value,
	pid: one value,
	initBidTriples:set bidTriple,
	pconnections: some pnode,
	p_T: one Int,
	P_U: one utility,
	P_RO: one release_outbid
}

sig vnode{vid: one value}

one sig slice{vns: set vnode, sInitiator: one pnode}

sig message{
	mSender: one pnode,
	mReceiver: one pnode,
	mBidTriples: set bidTriple
}

sig bidVector{
	bvPn:one pnode,
	bvBidTriples: set bidTriple,
	excludedVN: set vnode
}

sig netState {bidVectors: some bidVector, time: one value,buffMsgs: set message}

sig bidTriple{
	bidTriple_v: one vnode,
	bidTriple_b: one value,
	bidTriple_t: one value,
	bidTriple_w: one (pnode + NULL)
}
