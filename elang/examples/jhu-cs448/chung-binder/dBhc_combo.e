#!/usr/bin/env rune

# Copyright 2004 Kevin Chung, Keith Binder under the terms of the
# MIT X license found at http://www.opensource.org/licenses/mit-license.html

# Theory of Network Communication - 600.348
# dBhc_combo.e - Final Project
# deBruijn Graph & Hypercube combination
# Due: 12/17/04

def NodePair := Tuple[int, rcvr]

def dBhcFile(addr :int) :any {
    return <file: `dBhc-$addr.cap`>
}

def objFromFile(file) :any {
    if (file.exists()) {
        return introducer.sturdyFromURI(file.getText()).getRcvr()
    } else {
        return null
    }
}

def objIntoFile(obj, file) :void {
    file.setText(introducer.sturdyToURI(makeSturdyRef.temp(obj)))
}

def findLevel(myAddr) :any {
  var temp := 0
  while (2**temp <= myAddr) { temp := temp + 1 }
  return temp-1
}

def calcdBNum(myAddr) :any {
  var lev := findLevel(myAddr)
  var addr := myAddr - (2**lev)
  var c := lev - 1
  var dBstr := ``
  while (c >= 0) {
    if (addr // (2**c) == 1) {
      dBstr := `1` + dBstr
      addr := addr - 2**c
    } else {
      dBstr := `0` + dBstr
    }
    c := c - 1
  }
  return dBstr
}

def hypercubeEdges(msg :any, myAddr :int) :any {
  var lev := findLevel(myAddr)
  var addr := myAddr - (2**lev)
  var c := lev - 1
  var sAddr := addr
  var tAddr := 0
  def newmsg := msg + ` [$myAddr to hcube]`
  while (c >= 0) {
    if (addr // (2**c) == 1) {
      tAddr := sAddr - 2**c + (2**lev)
      var hc := [tAddr, objFromFile(dBhcFile(tAddr))]
      hc[1] <- U_Forward(newmsg, myAddr)
      addr := addr - 2**c
    } else {
      tAddr := sAddr + 2**c + (2**lev)
      var hc := [tAddr, objFromFile(dBhcFile(tAddr))]
      hc[1] <- U_Forward(newmsg, myAddr)
    }
    c := c - 1
  }
}

def makeNode(myAddr :int) :any {
  def node
  var myself :NodePair := [myAddr, node]
  var parent := var lchild := var rchild := var dB := var num := null

bind node {

  to setParent (w) :any { parent := w }
  to setLeftChild (w) :any { lchild := w }
  to setRightChild (w) :any { rchild := w }
  to setdB (w) :any { dB := w }
  to setNum (w) :any { num := w }

  to getInfo(w) :any {
    num := w[0]
    var p2 := var lc2 := var rc2 := null
    if (parent != null) { p2 := parent[0] }
    if (lchild != null) { lc2 := lchild[0] }
    if (rchild != null) { rc2 := rchild[0] }
    println(`UPDATE: Parent node updating values...`)
    println(`node: $num | dB: $dB | parent: $p2 | lchild: $lc2 | rchild: $rc2`)
    println(``)
  }

  to getParent() :any { return parent }
  to getLeftChild() :any { return lchild }
  to getRightChild() :any { return rchild }
  to getdB() :any { return dB }
  to getNum() :any { return num }

  to Join(myAddr) :any {
  if (myAddr != 1) {
    # Calculate node's parent
    # We check the inverse binary string of myAddr, ignoring the final bit
    # i.e. '11' in base 10 -> 1011 in base 2 -> '110(1)' when inverted
    var l := findLevel(myAddr)
    var lct := 0
    var tempAddr :int := myAddr
    var lr := 0
    while (lct < l) {
      if (tempAddr %% (2**(l - lct)) == tempAddr %% (2**(l - lct - 1))) {
        lr := 0
      } else {
        lr := 1
      }
      tempAddr := tempAddr %% (2**(l - lct))
      lct := lct + 1
    }
    var t1 := (myAddr - (myAddr%%2))/2
    t1 := t1.round()
    var par := [t1, objFromFile(dBhcFile(t1))]
    if (lr == 0) {
      println(`JOIN: Node $myAddr joining as left child of parent...`)
      par[1] <- setLeftChild(myself)
      println(par[1] <- getInfo(par))
    } else {
      println(`JOIN: Node $myAddr joining as right child of parent...`)
      par[1] <- setRightChild(myself)
      println(par[1] <- getInfo(par))
    }

    node.setParent(par)
    node.setLeftChild(null)
    node.setRightChild(null)
    node.setdB(calcdBNum(myAddr))
    node.setNum(myAddr)
    var p := var lc := var rc := null
    if (parent != null) { p := parent[0] }
    if (lchild != null) { lc := lchild[0] }
    if (rchild != null) { rc := rchild[0] }
    println(`node: $num | dB: $dB | parent: $p | lchild: $lc | rchild: $rc`)
    println(``)
    
  } else {
    var parent := null
    var lchild := null
    var rchild := null
    var dB := ``
    var num := myAddr
      
    #setNodesInUse(myAddr)
   # hypercubeEdges(1)
   # println(``)
   # hypercubeEdges(2)
   # println(``)
   # hypercubeEdges(3)
    #println(``)

    println(`JOIN: Root node $myAddr joining...`)
    println(`node: $num | dB: $dB | parent: $parent | lchild: $lchild | rchild: $rchild`)
    println(``)
  }
  }
  
  to Broadcast(msg :any, senderRef) :any {
    def newmsg := `BROADCAST: ` + msg
    node.B_Forward(newmsg, senderRef)
  }
  
  to B_Forward(msg :any, senderRef) :any {
    def newmsg := msg + ` [$myAddr]`
    if (parent != null && parent[0] != senderRef) {
      parent[1] <- B_Forward(newmsg, myAddr)
    }
    if (lchild != null && lchild[0] != senderRef) {
      lchild[1] <- B_Forward(newmsg, myAddr)
    }
    if (rchild != null && rchild[0] != senderRef) {
      rchild[1] <- B_Forward(newmsg, myAddr)
    }
    println(`$msg`)
  }
  
  to Unicast(msg :any, senderRef) :any {
    def newmsg := `UNICAST: ` + msg
    if (parent != null && parent[0] != senderRef) {
      def pmsg := newmsg + ` [$myAddr to parent]`
      parent[1] <- U_Forward(pmsg, myAddr)
    }
    if (lchild != null && lchild[0] != senderRef) {
      def lmsg := newmsg + ` [$myAddr to lchild]`
      lchild[1] <- U_Forward(lmsg, myAddr)
    }
    if (rchild != null && rchild[0] != senderRef) {
      def rmsg := newmsg + ` [$myAddr to rchild]`
      rchild[1] <- U_Forward(rmsg, myAddr)
    }
    hypercubeEdges(newmsg, myAddr)
    println(`$newmsg`)
  }
  
  to U_Forward(msg :any, senderRef) :any {
    println(`$msg`)
  }

  to Restructure(myAddr) :any {
  if (parent != null) {
    var par := parent
    var lev := findLevel(par[0])
    var addr := par[0] - (2**lev)
    var c := lev - 1
    var sAddr := addr
    var tAddr := 0
    var hcedge := null
    var r_done := 0
    while (c >= 0 && r_done == 0) {
      if (addr // (2**c) == 1) {
        tAddr := sAddr - 2**c + (2**lev)
        hcedge := objFromFile(dBhcFile(tAddr))
        if (hcedge == null) {
          r_done := 1
        }
        addr := addr - 2**c
      } else {
        tAddr := sAddr + 2**c + (2**lev)
        hcedge := objFromFile(dBhcFile(tAddr))
        if (hcedge == null) {
          r_done := 1
        }
      }
      c := c - 1
    }
    if (r_done == 0) {
      println(`RESTRUCTURE: Restructure failed.  Node $myAddr could not be moved to open node.`)
    } else {
    println(`RESTRUCTURE: Node $myAddr (dB: ` + node.getdB() + `) forwarded request to node `+par[0]+` (dB: `+calcdBNum(par[0])+`)`)
    println(`Node $myAddr moved to $tAddr (dB: `+calcdBNum(tAddr)+`)`)
    println(``)
    node.Leave(myAddr)
    par[1] <- getInfo(par)
    println(``)
    node.Join(tAddr)
    }
  }
  }
  
  to Leave(myAddr) :any {
    if (lchild == null && rchild == null) {
      if (myAddr %% 2 == 0) {
        parent[1] <- setLeftChild(null)
      } else {
        parent[1] <- setRightChild(null)
      }
      node.setParent(null)
      node.setLeftChild(null)
      node.setRightChild(null)
      node.setdB(null)
      node.setNum(null)     
      println(`LEAVE: Node $myAddr leaving...`)
    } else {
      println("Node $myAddr cannot leave network; not leaf node")
    }
  }
}

objIntoFile(node, dBhcFile(myAddr))
return node
}

if (interp.getArgs() =~ [myAddrStr]) {
    def myAddr := __makeInt(myAddrStr)
    introducer.onTheAir()
    makeNode(myAddr)
    println(`Node $myAddr ready...`)
    println(``)
    interp.blockAtTop()
} else {
    println("usage: dBhc_combo.e [node]")
}