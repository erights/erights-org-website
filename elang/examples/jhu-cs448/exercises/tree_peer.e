#!/usr/bin/env rune

# Copyright 2004 Pavan Piratla, Nilo Rivera and Sandeep Ranade under the terms 
# of the MIT X license
# found at http://www.opensource.org/licenses/mit-license.html ................

# The above copyright notice was added by Mark S. Miller after obtaining
# verbal permission from the three authors to do so.

#*******************************************************************************
#Tree Peer Code
#
#Partners :- Pavan Piratla , Nilo Rivera and Sandeep Ranade
#
#Please see attached ReadME document for operational instructions
#*******************************************************************************

def myName
def super

def supervisorFile() :any {
    return <file: `tree-sup.cap`>
}

def peerFile(name) :any {
    return <file: `tree-peer-$name.cap`>
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

def Peer() :any{
  var label := 0
  var succ := null
  var pred := null
  var parent := null
  var lchild := null
  var rchild := null
  def sc 
  
  #sc := newContact() # this is the contact point of v
  #Register(sc)    # this sends a request to sc that is forwarded to v
  
  def join (s) :any {
      if (s != null) {
          s <- Join(sc)
          super := s #current supervisor
      }
  }
   
  def leave() :any {
      if (super != null) {
         super <- Leave(label, pred, succ, parent, lchild, rchild)
      }
      println(`Node [$myName] leaving`)
      #interp.exitAtTop()
  }
   
  def setup(l, p, s, f, lc, rc) :any {
      println(`Peer_Setup`)
      label := l
      pred := p
      succ := s
      parent := f
      lchild := lc
      rchild := rc
      println(`My Label Index is [$label]`)
  }
   
  def remoteCalls {
    to Setup(l, p, s, f, lc, rc) :any {
      setup(l, p, s, f, lc, rc)
    }
    
    to Leave() :any {
      leave()
    }
    
    to setSucc(w) :any {
      succ := w
    }
  
    to setPred (w) :any {
      pred := w
    }
  
    to setParent (w) :any {
      parent := w
    }
  
    to setLeftChild (w) :any {
      lchild := w
    }
  
    to setRightChild (w) :any {
      rchild := w
    }
  
    to getSucc () :any {
      return succ
    }
  
    to getPred () :any {
      return pred
    }
   
    to getPredPred() :any {
      return pred <- getPred()
    }
    
    to getLabel() :any {
      return label
    }
    
    to Broadcast(msg :any, senderRef) :any {
      # Will add my string to the current string, 
      # call broadcast to parent and childs.
      def newmsg := msg + ` [$myName]`
      if (parent != null && parent != senderRef) {
        parent <- Broadcast(newmsg, sc)
      }
      if (lchild != null && lchild != senderRef) {
        lchild <- Broadcast(newmsg, sc)
      }
      if (rchild != null && rchild != senderRef) {
        rchild <- Broadcast(newmsg, sc)
      }
      println(`$msg`)
    }
  }
  # Only need this to be able to broadcast from console
  objIntoFile(remoteCalls, peerFile(myName))
  
  bind sc := remoteCalls
  return remoteCalls
}

if (interp.getArgs() =~ [Name]) {
    bind myName := Name
    introducer.onTheAir()
    println(`Initializing Peer [$myName]`)
    bind super := objFromFile(supervisorFile())
    def myRemoteCalls := Peer()
    super <- Join(myRemoteCalls)
    interp.blockAtTop()
} else {
    println("usage: tree_peer.e label")
}    



