#!/usr/bin/env rune

# Copyright 2004 Mark S. Miller & Sandeep Ranade under the terms of the
# MIT X license found at http://www.opensource.org/licenses/mit-license.html ..

def peerFile(name) :any {
    return <file: `peer-$name.cap`>
}

def objFromFile(file) :any {
    return introducer.sturdyFromURI(file.getText()).getRcvr()
}

def objIntoFile(obj, file) :void {
    file.setText(introducer.sturdyToURI(makeSturdyRef.temp(obj)))
}

# Each peer-connection is represented as a pair: [name, peer]
# where 'name' is a String and 'peer' is a reference of some sort (possibly a
# promise or a far reference) to a peer with that name. The following guard
# expresses the type constraint "a pair of a String and anything". So long as
# the values in question satisfy this guard, use of this guard does not
# effect the meaning of the program. It just helps us say what we mean, and
# catch bugs early.
def PeerPair := Tuple[String, rcvr]

# A Message is represented by a pair of a message-name, which is a String, and
# a list of arguments. Again, the use of this guard helps us catch bugs early,
# but does not otherwise effect the meaning of a program
def Message := Tuple[String, any[]]

/**
 * Used for a cyclic magnitude comparison between three Strings, or between
 * three pairs, each of whose first elements are a String.
 * <p>
 * Since names are arbitrary, but lexicographically sorted, and since they go
 * around in a cycle, normal "<", etc, kinds of tests aren't meaningful.
 * Rather, the right test asks whether three values are unequal and go around
 * a cycle in clockwise order. For three unequal, fully ordered values, if
 * they aren't in clockwise order, then they're in a counterclockwise order.
 */
def isClockwise(x, y, z) :boolean {
    # Since E overloads only on arity, not on type, we use a switch to
    # simulate type-based overloading.
    switch ([x,y,z]) {
        match [xStr :String, yStr :String, zStr :String] {
            if (xStr < yStr) {
                if (yStr < zStr) {
                    # x,y,z
                    return true
                } else if (zStr < xStr) {
                    # z,x,y
                    return true
                } else {
                    # if unequal, then x,z,y
                    return false
                }
            } else if (yStr < zStr) {
                if (zStr < xStr) {
                    # y,z,x
                    return true
                } else {
                    # if unequal, then y,x,z
                    return false
                }
            } else {
                # if unequal, then z,y,x
                return false
            }
        }
        match [[xStr :String, _], [yStr :String, _], [zStr :String, _]] {
            return isClockwise(xStr, yStr, zStr)
        }
    }
}

/**
 * Do x and y represent the same peer?
 * <p>
 * As with isBetween, x and y may both be Strings, or they may both be pairs
 * whose first elements are strings. In the latter case, only these Strings
 * are compared.
 */
def isSamePeer(x,y) :boolean {
    switch([x,y]) {
        match [xStr :String, yStr :String] {
            return xStr == yStr
        }
        match [[xStr :String, _], [yStr :String, _]] {
            return isSamePeer(xStr,yStr)
        }
    }
}

/**
 * On a circle, is y between x and z?
 * <p>
 * This is the same as isClockwise(x,y,z) except that if x == z, then y is
 * considered to be between them. In this case, we don't care whether x == y.
 */
def isBetween(x,y,z) :boolean {
    return isClockwise(x,y,z) || isSamePeer(x,z)
}

def makePeer(myName :String) :any {
    
    def peer
    def myself :PeerPair := [myName, peer]
    
    # This proper way to work out a problem like this is to state real
    # invariants that are true following each local atomic transition, and to
    # make sure that these invariants are satisfied for any interleaving of
    # these atomic transitions. However, this is hard, and beyond what the
    # present assignment calls for, so instead we're using this interlock
    # as a kludge to detect and reject the concurrent cases which would have
    # called for a proper solution.
    #
    # Instead of proper invariants, we instead have what we'll call
    # "q-invariants" -- invariants under connected quiescense. Given lack of
    # partition and no further external requests, eventually all previous
    # external requests will be acknowledged. Once all previous external
    # requests have been acknowledged, all nodes will be quiescent, i.e., not
    # busy. Therefore, so long as external requests are made one at a time,
    # i.e., after all previous requests are acknowledged, these requests should
    # never encounter a busy node.
    #
    # When we state a q-invariant involving nodes X, Y, and Z, we're
    # effectively stating an invariant that says, if none of these nodes are
    # busy then the q-invariant holds. Put another way, being busy is an
    # adequate excuse for violating a stated q-invariant.
    #
    # If a request encounters a busy node, it may fail. However, it may
    # fail after having brought about state changes at non-busy nodes. Should
    # this happen, it is beyond the scope of the assignment to try to restore
    # consistency, so following a reported failure indicates that the network
    # may now be in an inconsistent state, and any requests which may occur
    # concurrently or afterwards are no longer guaranteed to be processed
    # correctly. (Frankly, this stinks. But it turned out to be hard to do
    # better, so we didn't.)
    #
    var amBusy :boolean := false
    
    # invariants:
    #     For ring N, for any node p:
    #         p.nextN and p.prevN are each a [name,peer] pair describing a
    #         connection to a given peer, as explained above. The statements
    #         of (q-)invariants below elides the distinction between a peer
    #         and the pair describing that peer.
    #         isBetween(p, p.nextN, p.nextN.nextN)
    #         isBetween(p.prevN.prevN, p.prevN, p)
    # q-invariants:
    #     For ring N, for any node p:
    #         p.nextN.prevN == p.prevN.nextN == p
    #         Let ringN(p) == the list starting at p following nextN pointers
    #                         until we get to a q s.t. q.nextN == p.
    #             The list is finite and has no duplicates.
    #             For any three distinct elements of the list x,y,z, in the
    #             order they appear in the list, isClockwise(x,y,z)
    #         The above q-invariants capture the notion of a ring that meets
    #         itself after only going around once.
    #   Higher rings are subsets of lower rings:
    #     x in ringN(p) implies x in ringN+1(p)
    #   The normal alternation or bridge property:
    #     p.nextN+1 is one of p.nextN, p.nextN.nextN, or p.nextN.nextN.nextN
    #     Aha! This implies a locally checkable property: that
    #       p.prevN != p.prevN+1 || p.nextN != p.nextN+1
    #       In other words, we can't have two 1-long ring-1 hops in a row,
    #       as that would imply that the alternate ring1 would have to skip]
    #       both hops (and therefore 3 nodes) in a single bound.
    #     Oops, not quite. When the ring only consists of 1 node, then
    #       p.prevN == p.prevN+1 && p.nextN == p.nextN+1
    #
    # On both the 0-ring and the 1-ring, I'm initialized to point at myself
    #
    var next0 :PeerPair :=
      var prev0 :PeerPair :=
      var next1 :PeerPair :=
      var prev1 :PeerPair := myself
    
    # I'm alone until someone (who's alone) joins me, or I join someone else.
    # Once I'm not alone, then others can still join me, in order to join my
    # ring, but I can no longer join anyone else.
    #
    # q-invariant: amAlone implies next0 == prev0 == next1 == prev1 == myself
    #
    var amAlone :boolean := true
    
    /**
     * Is are both my previous and next ring1 hops 1 long on a non-singleton
     * ring?
     * <p>
     * If so, then we're in violation of a q-inavriant, and need to adjust
     * things.
     */
    def tooTight() :boolean {
        if (isSamePeer(next0,myself)) {
            # I'm in a singleton ring, i.e., a ring containing only me.
            return false
        } else {
            return isSamePeer(prev1,prev0) && isSamePeer(next1,next0)
        }
    }
    
    bind peer {
        
        /**
         * This is a convenience method which obtains the actual reference to
         * the member by mangling the name into a filename to read and calls
         * joinRing, which does all the work.
         *
         * @see #joinRing
         */
        to join(memberName :String) :vow[nullOk] {
            return peer.joinRing([memberName,
                                  objFromFile(peerFile(memberName))])
        }
        
        /**
         * An external request (see above) to join the hyper-ring containing
         * the given member.
         * <p>
         * This node (the one receiving the joinRing request) must be alone and
         * not busy. The request isn't successfully completed until the
         * returned result resolves to null. If it instead becomes broken, then
         * all bets are off, as explained above.
         */
        to joinRing([memberName :String, member]) :vow[nullOk] {
            if (!amAlone) { throw(`$myName is already in a ring`) }
            if (amBusy)   { throw(`$myName is busy -- try again later`) }
            if (myName == memberName) { throw(`$myName already taken`) }
            
            amBusy := true
            
            # Asks some arbitrary member of a ring to route the message
            # "<- spliceIn(myself)" to the ring member whose name is the
            # closest successor of myName. This is the ring member that
            # should become my immediate successor.
            def newState := member <- route(myName, ["spliceIn", [myself]])
            
            return when (newState) ->
              addDone([newNext0,newPrev0,newNext1,newPrev1]) :nullOk {
                amAlone := false
                next0 := newNext0
                prev0 := newPrev0
                next1 := newNext1
                prev1 := newPrev1
                amBusy := false
                require(!tooTight())
                return null
            } catch excuse {
#                amBusy := false
                throw(excuse)
            }
        }
        
        /**
         * An external request (see above) to leave the hyper-ring, if any,
         * that I'm a member of.
         * <p>
         * Should the result of this resolve successfully (and therefore to
         * null), then the remaining hyper-ring will still be well formed and
         * I will become alone again (and therefore able to join a hyper-ring).
         * If the result instead becomes broken, then all bets are off as
         * explained above.
         */
        to leaveRing() :vow[nullOk] {
            if (amBusy) { throw(`$myName is busy -- try again later`) }
            if (amAlone) { return null }
            
            if (isSamePeer(next0, myself)) {
                # next0 can only be me if I'm the only one in the ring
                require(isSamePeer(prev0, myself))
                require(isSamePeer(next1, myself))
                require(isSamePeer(prev1, myself))
                amAlone := true
                return null
            }
            amBusy := true
            def ack := next0[1] <- spliceOut(prev0, next1, prev1)
            return when (ack) -> leaveDone(_) :nullOk {
                next0 := prev0 := next1 := prev1 := myself
                amAlone := true
                amBusy := false
                require(!tooTight())
                return null
            } catch excuse {
#                amBusy := false
                throw(excuse)
            }
        }
        
        /**
         * Delivers msg to the node whose myName is name, or is the closest
         * successor of name.
         * <p>
         * Although this is an external request, since it is also used
         * internally, we only refuse to route from a node that's both alone
         * and busy. For all the others, we need to make this work. For
         * example, if sent to a node that's in the middle of leaving a
         * hyper-ring, that node will still forward the message to its (about
         * to be former) neighbors.
         */
        to route(name :String, msg :Message) :any {
            if (amBusy && amAlone) { throw(`$myName can't yet route`) }
            
            if (name == myName || isBetween(prev0[0], name, myName)) {
                # The message is for me
                def [verb, args] := msg
                return E.call(peer, verb, args)
            } else if (isBetween(myName, name, next1[0])) {
                # The destination is between me and my next ring1 hop, so
                # forward it on ring0
                return next0[1] <- route(name, msg)
            } else {
                # forward it on ring1
                return next1[1] <- route(name, msg)
            }
        }
        
        /**
         * newPrev0 must be a valid new predecessor for the current node.
         * <p>
         * Should the operation complete successfully, the result will resolve
         * to the list of four peers that the new member should remember as its
         * new [next0,prev0,next1,prev1] neighbors.
         */
        to spliceIn(newPrev0 :PeerPair) :vow[Tuple[PeerPair,
                                                   PeerPair,
                                                   PeerPair,
                                                   PeerPair]] {
            if (amBusy) { throw(`$myName is busy -- try again later`) }
            require(isBetween(prev0,newPrev0,myself))
            require(!isSamePeer(newPrev0, myself))
            
            amBusy := true
            amAlone := false
            def oldPrev0 := prev0
            prev0 := newPrev0
            def ack0 := oldPrev0[1] <- swapNext0(newPrev0)
            if (isSamePeer(next0, myself)) {
                # next0 can only be me if I'm the only one in the ring
                require(isSamePeer(oldPrev0, myself))
                require(isSamePeer(next1, myself))
                require(isSamePeer(prev1, myself))
                next0 := newPrev0
                amBusy := false
                require(!tooTight())
                return [myself,myself,newPrev0,newPrev0]
                
            } else if (isSamePeer(next0, next1)) {
                # The next ring1 hop is only 1 long, so the previous ring1 hop,
                # must be longer.
                require(!isSamePeer(oldPrev0, prev1))
                
                # Therefore, newPrev0 should take my place on ring1
                def oldNext1 := next1
                def ack1 := oldNext1 <- swapPrev1(newPrev0)
                def oldPrev1 := prev1
                def ack2 := oldPrev1 <- swapNext1(newPrev0)
                
                # and I should splice myself into oldPrev0's ring1
                def newNext1 := oldPrev0[1] <- swapNext1(myself)
                def ack3 := newNext1 <- get(1) <- swapPrev1(myself)
                prev1 := oldPrev0
                return when (ack0,newNext1,ack1,ack2,ack3) ->
                  doneSpliceIn2(_,_,_,_,_) :Tuple[PeerPair,
                                                  PeerPair,
                                                  PeerPair,
                                                  PeerPair] {
                    next1 := newNext1
                    amBusy := false
                    require(!tooTight())
                    return [myself,oldPrev0,oldNext1,oldPrev1]
                } catch excuse {
#                    amBusy := false
                    throw(excuse)
                }
            } else {
                # My next ring1 hop is > 1
                require(!isSamePeer(next0, next1))
                # Therefore, the new node must be placed on my next0's ring1
                # rather than my own.
                def oldNext0Prev1 := next0[1] <- swapPrev1(newPrev0)
                def ack1 := oldNext0Prev1 <- get(1) <- swapNext1(newPrev0)
                return when (ack0,oldNext0Prev1,ack1) ->
                  doneSpliceIn1(_,_,_) :Tuple[PeerPair,
                                              PeerPair,
                                              PeerPair,
                                              PeerPair] {
                    amBusy := false
                    require(!tooTight())
                    return [myself,oldPrev0,next0,oldNext0Prev1]
                } catch excuse {
#                    amBusy := false
                    throw(excuse)
                }
            }
        }
        
        /**
         * My prev0 is leaving, and telling me of his prev0,next1,prev1
         * neighbors, so I can arrange for all of us to forget him.
         * <p>
         * He doesn't tell me about his next0 neighbor because that's me.
         * <p>
         * If nothing goes wrong, once the hyper-ring is restored to a
         * consistent state which doesn't include him, I resolve the returned
         * promise to null. Only then will he change his state to stop routing
         * messages into the hyper-ring.
         */
        to spliceOut(exPrev0 :PeerPair,
                     exNext1 :PeerPair,
                     exPrev1 :PeerPair) :vow[nullOk] {
            if (amBusy) { throw(`$myName is busy -- try again later`) }
            require(!isSamePeer(prev0,myself))
            
            amBusy := true
            def oldPrev0 := prev0
            prev0 := exPrev0
            def ack0 := exPrev0[1] <- swapNext0(myself)
            if (isSamePeer(exNext1, myself) || isSamePeer(exNext1, next0)) {
                # If I was on oldPrev0's ring1, my next ring1 hop must
                # be bigger than 1. Or if next0 is on oldPrev0's ring1, then
                # I'm not, so my next ring1 hop is still > 1.
                require(!isSamePeer(next0, next1))
                # In either case, we can just splice him out
                def ack1 := exPrev1[1] <- swapNext1(exNext1)
                def ack2 := exNext1[1] <- swapPrev1(exPrev1)
                return when (ack0,ack1,ack2) ->
                  doneSpliceOut1(_,_,_) :vow[nullOk] {
                    amBusy := false
                    require(!tooTight())
                    
                    # At this point, I am locally well formed, but if my new
                    # prev0 may be too tight, give him a chance to adjust.
                    if (isSamePeer(prev0,prev1)) {
                        return prev0[1] <- adjust(exNext1,exPrev1)
                    } else {
                        return null
                    }
                } catch excuse {
#                    amBusy := false
                    throw(excuse)
                }
            } else {
                # My next ring1 hop is 1
                require(isSamePeer(next0, next1))
                # and my previous is > 1
                require(!isSamePeer(oldPrev0, prev1))
                # So I will splice myself out of ring1
                def ack1 := prev1[1] <- swapNext1(next1)
                def ack2 := next1[1] <- swapPrev1(prev1)
                # and assume oldPrev0's position on ring1
                if (isSamePeer(oldPrev0,exNext1)) {
                    # oldPrev0 was by himself on his own ring 1, so now we
                    # become alone on ours
                    next1 := prev1 := myself
                    return when (ack0,ack1) ->
                      doneSpliceOut2(_,_) :nullOk {
                        require(!tooTight())
                        amBusy := false
                        return null
                    } catch excuse {
#                    amBusy := false
                        throw(excuse)
                    }
                } else {
                    next1 := exNext1
                    prev1 := exPrev1
                    def ack3 := prev1[1] <- swapNext1(myself)
                    def ack4 := next1[1] <- swapPrev1(myself)
                    return when (ack0,ack1,ack2,ack3) ->
                      doneSpliceOut3(_,_,_,_) :nullOk {
                        require(!tooTight())
                        amBusy := false
                        return null
                    } catch excuse {
#                    amBusy := false
                        throw(excuse)
                    }
                }
            }
        }
        /**
         *
         */
        to adjust(exNext1 :PeerPair, exPrev1 :PeerPair) :vow[nullOk] {
            if (tooTight()) {
                # I splice myself out of my ring1
                def ack0 := next1[1] <- swapPrev1(prev1)
                def ack1 := prev1[1] <- swapNext1(next1)
                # and splice myself into exNext1/exPrev1's ring1
                next1 := exNext1
                prev1 := exPrev1
                def ack2 := next1[1] <- swapPrev1(myself)
                def ack3 := prev1[1] <- swapNext1(myself)
                return when (ack0,ack1,ack2,ack3) ->
                  adjustDone(_,_,_,_) :nullOk {
                    return null
                } catch excuse {
                    throw(excuse)
                }
            } else {
                return null
            }
        }
        
        to swapNext0(newNext0 :PeerPair) :PeerPair {
            try {
                return next0
            } finally {
                next0 := newNext0
            }
        }
        
        to swapPrev0(newPrev0 :PeerPair) :PeerPair {
            try {
                return prev0
            } finally {
                prev0 := newPrev0
            }
        }
        
        to swapNext1(newNext1 :PeerPair) :PeerPair {
            try {
                return next1
            } finally {
                next1 := newNext1
            }
        }
        
        to swapPrev1(newPrev1 :PeerPair) :PeerPair {
            try {
                return prev1
            } finally {
                prev1 := newPrev1
            }
        }
        
        to printOn(out) :vow[nullOk] {
            return peer.printOn(myName, out)
        }
        
        to printOn(startName :String, out) :vow[nullOk] {
            def flag := if (tooTight()) { "*" } else { "" }
            def ack0 := out <- println(
                `$myName:[${next0[0]},${prev0[0]},${next1[0]},${prev1[0]}]$flag`)
            if (startName == next0[0]) {
                return ack0
            } else {
                def ack1 := next0[1] <- printOn(startName, out)
                return when(ack0,ack1) -> done(_,_) :nullOk {
                    return null
                } catch excuse {
                    throw(excuse)
                }
            }
        }
    }
}

def Resolver := <type:org.erights.e.elib.ref.Resolver>

switch (interp.getArgs()) {
    match [name :String] {
        introducer.onTheAir()
        def peer := makePeer(name)
        objIntoFile(peer, peerFile(name))
        println(`peer $name ready`)
        interp.blockAtTop()
    }
    match [name :String, resolver :Resolver] {
        introducer.onTheAir()
        def peer := makePeer(name)
        resolver.resolve([name, peer])
        interp.blockAtTop()
    }
    match _ {
        println("usage: hyper-ring.e Name [<Resolver>]")
    }
}

