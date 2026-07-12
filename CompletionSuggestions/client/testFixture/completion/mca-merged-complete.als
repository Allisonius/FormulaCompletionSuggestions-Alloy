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

fact {one v:value | no v.succ}
fact {one v:value | no v.pre}
fact {all v:value |  !(v in v.pre) and !(v in v.succ) and no(v.succ & v.pre)}
fact {all disj v1,v2,v3: value |
		((v1 in v2.pre and v2 in v3.pre) implies (v1 in v3.pre)) and
		((v1 in v2.succ and v2 in v3.succ) implies (v1 in v3.succ))
}
fact {all disj v1,v2: value | (v1 in v2.pre) or (v1 in v2.succ)}
fact {all disj v1,v2: value | (v1 in v2.pre) implies ( (v2 in v1.succ) and !(v1 in v2.succ) )}
fact {all disj v1,v2: value | (v2 in v1.succ) implies ( (v1 in v2.pre) and !(v2 in v1.pre) )}

pred valL(v1,v2: value){
	v1 in v2.pre
}

pred valG(v1,v2: value){
	v1 in v2.succ
}

pred valLE(v1,v2: value){
	(v1 = v2) or (v1 in v2.pre)
}

pred valGE(v1,v2: value){
	(v1 = v2) or (v1 in v2.succ)
}

fun findBidVecByPn(bvs: set bidVector, p:one pnode): one bidVector {bvPn.p & bvs}

fun vnodesWonBy(bv: bidVector): set vnode {(bidTriple_w.(bv.bvPn) & bv.bvBidTriples).bidTriple_v}

fun findBidTriple(bts: set bidTriple, v: vnode): one bidTriple {bidTriple_v.v & bts}

fact{!(pnode.initBidTriples.bidTriple_b = zero)}

fact{all bt: bidTriple |
	(bt.bidTriple_b = zero implies (bt.bidTriple_t = zero and bt.bidTriple_w = NULL)) and
	(bt.bidTriple_w = NULL implies (bt.bidTriple_t = zero and bt.bidTriple_b = zero))
}

fact {
	all bv:bidVector |
	(
		(bv.bvPn.P_U = utility_submodular) implies
			all disj v1, v2: vnodesWonBy[bv] |
				valL[v1.vid, v2.vid] implies
				(
				(valL[findBidTriple[bv.bvBidTriples, v1].bidTriple_t, findBidTriple[bv.bvBidTriples, v2].bidTriple_t]) and
				(valGE[findBidTriple[bv.bvBidTriples, v1].bidTriple_b, findBidTriple[bv.bvBidTriples, v2].bidTriple_b])
			)
	)
}

fact{all disj pn1,pn2:pnode |( pn1.pid != pn2.pid) and (pn1 in pn2.pconnections <=> pn2 in pn1.pconnections)}

fact{
	all pn:pnode | (pn in (slice.sInitiator). *pconnections) and no (pn & pn.pconnections) and (pn.p_T =< #(vnode))
}

fact{
	all pn: pnode| all bt: pn.initBidTriples |
				!(bt.bidTriple_b = zero) implies (bt.bidTriple_w = pn)
									  else (bt.bidTriple_w = NULL)
}

fact {all pn: pnode |
	#(pn.initBidTriples) = #(vnode) and
	pn.initBidTriples.bidTriple_v = vnode
}

fact {all initB : pnode.initBidTriples| valL[initB.bidTriple_t, first.time]}

fact{all disj vn1, vn2: vnode | vn1.vid != vn2.vid}

fact{all m:message |
	#(m.mBidTriples) = #(vnode) and
	m.mBidTriples.bidTriple_v = vnode and
	m.mSender != m.mReceiver
}

fact {all m:message | some s:netState | m in s.buffMsgs}

fact {all s: netState, ss: s.next | one m:message | messaging[s, ss, m]}

fact {all s: netState |
	#(s.bidVectors) = #(pnode) and
	(s.bidVectors.bvPn = pnode)
}

fact {all b: first.bidVectors |
	b.bvBidTriples = b.bvPn.initBidTriples and
	no b.excludedVN
}

fact { all p:pnode |
		p in slice.sInitiator.pconnections
			implies (one m:first.buffMsgs |
							m.mReceiver = p and
							m.mSender = slice.sInitiator and
							m.mBidTriples = slice.sInitiator.initBidTriples
					)
}

fact{#(first.buffMsgs) = #(slice.sInitiator.pconnections)}

fact {slice.vns = vnode}

fact{all b:bidVector | all xv: b.excludedVN | !( findBidTriple[b.bvBidTriples, xv].bidTriple_w in (NULL+b.bvPn))}

fact {all b:bidVector |
			#(b.bvBidTriples) = #(vnode) and
			b.bvBidTriples.bidTriple_v = vnode
}

fact{all b:bidVector | some s: netState | b in s.bidVectors }

pred messaging(s, ss: netState, m:message){
	bidVectorsConsistency[s, ss, m] and
	valG[ss.time, s.time] and
	(s.buffMsgs - ss.buffMsgs) = m and
	(s.bidVectors.excludedVN in ss.bidVectors.excludedVN) and
	(
	allVnodesDoNothing[s,m]
			implies
					(
						#(ss.buffMsgs - s.buffMsgs) = 0 and
						ss.bidVectors = s.bidVectors
					)
			else (m.mReceiver.P_RO = release_outbid_yes) implies
					(
						 checkAllOfVnodes[s, ss, m] and
						 broadCastToAll[ss,m]
					)
			else (
				#(ss.buffMsgs - s.buffMsgs) = #( m.mReceiver.pconnections) and
				(
	 				(one v:vnode | (outBid[s, v, m] and updateAndRebid[s, ss, v, m]))
						or
					((no v:vnode | outBid[s, v, m]) and  checkAllOfVnodes[s, ss, m])
				) and
				broadCastToAll[ss,m]
				)
	)
}

pred updateAndRebid(s,ss:netState, v: vnode, m:message){
	((findBidVecByPn[ss.bidVectors, m.mReceiver].excludedVN - findBidVecByPn[s.bidVectors, m.mReceiver].excludedVN) = v)
	and
	(all vv:  (vnodesWonBy[findBidVecByPn[s.bidVectors, m.mReceiver]] - v)
		| valG[vv.vid, v.vid] implies (releaseOrRebid[s, ss,vv,m.mReceiver])
	else (checkBidAndTime[s, ss, vv, m]) )
	and
	(all vv: (vnode - vnodesWonBy[findBidVecByPn[s.bidVectors, m.mReceiver]]) | checkRestOfVnodes[s,ss,vv,m] )
	and
	outBidUpdateAndRebroadcast[s,ss,v,m]
}

pred checkRestOfVnodes(s,ss:netState, v: vnode, m:message){
	(	findBidTriple[m.mBidTriples, v].bidTriple_w  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w
		and ( findBidTriple[m.mBidTriples, v].bidTriple_b  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b )
		and ( valLE[findBidTriple[m.mBidTriples, v].bidTriple_t , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t] ))
	implies (doNothing[s, ss, v, m])

	else 			( !( findBidTriple[m.mBidTriples, v].bidTriple_w  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w )
		and !( findBidTriple[m.mBidTriples, v].bidTriple_w  in (m.mReceiver + NULL))
		and !( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  in (m.mSender + NULL))
		and ( findBidTriple[m.mBidTriples, v].bidTriple_b  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b )
		and ( valL[findBidTriple[m.mBidTriples, v].bidTriple_w .pid, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w .pid])  )
	implies (updateAndRebroadcast[s, ss, v, m])

	else			( !( findBidTriple[m.mBidTriples, v].bidTriple_w  in (m.mReceiver+m.mSender+NULL))
		and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  in (m.mSender + NULL) )  )
	implies (updateAndRebroadcast[s, ss, v, m])

	else 			( !( findBidTriple[m.mBidTriples, v].bidTriple_w  in (m.mReceiver+m.mSender+NULL))
		and !( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  in (m.mReceiver +m.mSender + findBidTriple[m.mBidTriples, v].bidTriple_w  + NULL) )
		and  !( findBidTriple[m.mBidTriples, v].bidTriple_b  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b )
		and ( valGE[findBidTriple[m.mBidTriples, v].bidTriple_t , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t] )  )
	implies (updateAndRebroadcast[s, ss, v, m])

	else 			( ( (findBidTriple[m.mBidTriples, v].bidTriple_w + findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w)  in (NULL+m.mSender) )
		and (findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w != findBidTriple[m.mBidTriples, v].bidTriple_w )  )
	implies (updateAndRebroadcast[s, ss, v, m])

	else 			( ( findBidTriple[m.mBidTriples, v].bidTriple_w  = NULL )
		and !( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  in (m.mReceiver +m.mSender + NULL) )
		and ( valG[findBidTriple[m.mBidTriples, v].bidTriple_t , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t] ) )
		implies (updateAndRebroadcast[s, ss, v, m])

	else 			( ( findBidTriple[m.mBidTriples, v].bidTriple_w  = m.mSender)
		and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  = m.mSender)
		and ( valG[findBidTriple[m.mBidTriples, v].bidTriple_t , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t] )  )
	implies (updateAndRebroadcast[s, ss, v, m])

	else 			(  ( findBidTriple[m.mBidTriples, v].bidTriple_w  = m.mSender)
		and !( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  in (m.mReceiver +m.mSender + NULL) )
		and  ( valG[findBidTriple[m.mBidTriples, v].bidTriple_b , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b]
				or
			valG[findBidTriple[m.mBidTriples, v].bidTriple_t , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t] )  )
	implies (updateAndRebroadcast[s, ss, v, m])

	else 			( ( findBidTriple[m.mBidTriples, v].bidTriple_w  = m.mReceiver)
		and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  = m.mSender))
	implies (resetAndRebroadcastStar[s, ss, v, m])

	else 			( ( findBidTriple[m.mBidTriples, v].bidTriple_w  = m.mReceiver)
		and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  = NULL))
	implies (rebroadcastStar[s, ss, v, m])

	else			rebroadcast[s, ss, v, m]
}

pred releaseOrRebid(s, ss:netState, v:vnode, p:pnode){
	one bv: ss.bidVectors | (bv.bvPn = p) and
			( (findBidTriple[bv.bvBidTriples, v].bidTriple_w =  p
				and valG[findBidTriple[bv.bvBidTriples, v].bidTriple_b, zero]
				and valL[findBidTriple[bv.bvBidTriples, v].bidTriple_t, ss.time]
				and valG[findBidTriple[bv.bvBidTriples, v].bidTriple_t , s.time])
			or
			(findBidTriple[bv.bvBidTriples, v].bidTriple_w =  NULL
				and findBidTriple[bv.bvBidTriples, v].bidTriple_b = zero
				and findBidTriple[bv.bvBidTriples, v].bidTriple_t = zero)
			)
}

pred outBid(s: netState, v: vnode, m: message){
	(
		!( findBidTriple[m.mBidTriples, v].bidTriple_w in (m.mReceiver+NULL)) and
		( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  = m.mReceiver)  and
		(
			valG[findBidTriple[m.mBidTriples, v].bidTriple_b , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b]  or
			(
				( findBidTriple[m.mBidTriples, v].bidTriple_b  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b )  and
				( valL[findBidTriple[m.mBidTriples, v].bidTriple_w.pid, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w .pid])
			)
		)
	) and
	(all vv: (vnode - v)|
		( !( findBidTriple[m.mBidTriples, vv].bidTriple_w in (m.mReceiver+NULL))
				and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, vv].bidTriple_w = m.mReceiver)
				and ( valG[findBidTriple[m.mBidTriples, vv].bidTriple_b, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, vv].bidTriple_b]
					or (( findBidTriple[m.mBidTriples, vv].bidTriple_b = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, vv].bidTriple_b)
				and ( valL[findBidTriple[m.mBidTriples, vv].bidTriple_w.pid, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, vv].bidTriple_w.pid])  )))
	implies (valG[vv.vid, v.vid])  )
}

pred checkAllOfVnodes(s, ss: netState, m: message){
	all v: vnode |(
			( !( findBidTriple[m.mBidTriples, v].bidTriple_w  in (m.mReceiver + NULL))
				and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  = m.mReceiver)
				and ( valG[findBidTriple[m.mBidTriples, v].bidTriple_b, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b] )  )
	implies (updateAndRebroadcast[s, ss, v, m])

			else			( !( findBidTriple[m.mBidTriples, v].bidTriple_w  in (m.mReceiver+NULL))
				and ( findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w  = m.mReceiver)
				and ( valL[findBidTriple[m.mBidTriples, v].bidTriple_b, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b] )  )
			implies (updateTimeAndRebroadcast[s, ss, v, m])

			else  		checkRestOfVnodes[s, ss, v, m]
	)
}

pred bidVectorsConsistency(s, ss: netState, m: message){
	all pn: (pnode - m.mReceiver) | findBidVecByPn[ss.bidVectors, pn] = findBidVecByPn[s.bidVectors, pn]
}

pred buffMsgConsitency (s,ss: netState, r: pnode, m: message){
	( allVnodesDoNothing[s,m] implies  (#(ss.buffMsgs - s.buffMsgs) = 0)
		else (#(ss.buffMsgs - s.buffMsgs) = #(r.pconnections))
	)
}

pred allVnodesDoNothing( s: netState, m: message){
all v: vnode |
	(findBidTriple[m.mBidTriples, v].bidTriple_w  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w)   and
	( findBidTriple[m.mBidTriples, v].bidTriple_b  = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b ) and
	( valLE[findBidTriple[m.mBidTriples, v].bidTriple_t , findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t] )
}

pred outBidUpdateAndRebroadcast(s, ss: netState, v: vnode, m: message){
	(fairPlay[s,ss,v,m] )
}

pred fairPlay(s, ss: netState, v: vnode, m: message){
	(one bv: ss.bidVectors |
		(bv.bvPn = m.mReceiver) and
		(findBidTriple[bv.bvBidTriples, v]  =  findBidTriple[m.mBidTriples, v] )
	)
}

pred updateAndRebroadcast(s, ss: netState, v: vnode, m: message){
	(one bv: ss.bidVectors |
		(bv.bvPn = m.mReceiver) and
		(findBidTriple[bv.bvBidTriples, v] =  findBidTriple[m.mBidTriples, v])
	)
}

pred updateTimeAndRebroadcast(s, ss: netState, v: vnode, m: message){
	(one bv: ss.bidVectors |
		(bv.bvPn = m.mReceiver) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_w =  findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_b =  findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b ) and
		(
			(valGE[findBidTriple[m.mBidTriples, v].bidTriple_t, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t])
				implies (findBidTriple[bv.bvBidTriples, v].bidTriple_t = findBidTriple[m.mBidTriples, v].bidTriple_t)
				else (findBidTriple[bv.bvBidTriples, v].bidTriple_t = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t )
		)
	)
}

pred doNothing(s, ss: netState, v: vnode, m: message){
    (one bv: ss.bidVectors |
		(bv.bvPn = m.mReceiver) and
		(findBidTriple[bv.bvBidTriples, v] =  findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v])
	)
}

pred rebroadcast(s, ss: netState, v: vnode, m: message){
	doNothing[s,ss,v,m]
}

pred resetAndRebroadcastStar(s, ss: netState, v: vnode, m: message){
	(one bv: ss.bidVectors |
		(bv.bvPn = m.mReceiver) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_w =  NULL) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_b = zero) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_t =  ss.time)
	)
}

pred rebroadcastStar(s, ss: netState, v: vnode, m: message){
	 (one bv: ss.bidVectors |
		(bv.bvPn = m.mReceiver) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_w =  findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_w) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_b =  findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b ) and
		(findBidTriple[bv.bvBidTriples, v].bidTriple_t =  ss.time)
	)
}

pred broadCastToAll(ss: netState, m: message){
	all c: m.mReceiver.pconnections  | one mm: message |
		(mm.mSender = m.mReceiver) and (mm.mReceiver = c ) and
		(mm.mBidTriples = findBidVecByPn[ss.bidVectors, m.mReceiver].bvBidTriples) and
		(mm in ss.buffMsgs)
}

pred checkBidAndTime(s, ss: netState, v: vnode, m: message){
	(
		!(findBidTriple[m.mBidTriples, v].bidTriple_w in (m.mReceiver + NULL)) and
		( valL[findBidTriple[m.mBidTriples, v].bidTriple_b, findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_b])
	) implies (updateTimeAndRebroadcast[s, ss, v, m])
	else (
		(findBidTriple[m.mBidTriples, v].bidTriple_w = m.mReceiver) and
		(findBidTriple[m.mBidTriples, v].bidTriple_t = findBidTriple[findBidVecByPn[s.bidVectors, m.mReceiver].bvBidTriples, v].bidTriple_t)
	) implies (doNothing[s, ss, v, m])
	else
		rebroadcast[s, ss, v, m]
}

pred consensusPred{
	some s: (netState - first) | all disj bv1,bv2: s.bidVectors | all v: vnode |
		(
			(findBidTriple[bv1.bvBidTriples, v].bidTriple_w = findBidTriple[bv2.bvBidTriples, v].bidTriple_w) and
			(findBidTriple[bv1.bvBidTriples, v].bidTriple_b = findBidTriple[bv2.bvBidTriples, v].bidTriple_b) and
			(findBidTriple[bv1.bvBidTriples, v].bidTriple_t = findBidTriple[bv2.bvBidTriples, v].bidTriple_t)
		)
}

assert consensus{
	(#(netState) >= 10) implies (consensusPred)
}
check consensus for 10 but exactly 16 value, exactly 2 pnode, exactly 2 vnode

assert numOfStates{
	!(#(netState) >= 10)
}
check numOfStates for 10 but exactly 16 value, exactly 2 pnode, exactly 2 vnode
