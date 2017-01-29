#!/usr/bin/env rune

# Copyright 2004 Pavan Piratla, Nilo Rivera and Sandeep Ranade under the terms 
# of the MIT X license
# found at http://www.opensource.org/licenses/mit-license.html ................

# The above copyright notice was added by Mark S. Miller after obtaining
# verbal permission from the three authors to do so.

#*******************************************************************************
#Tree Supervisor Code
#
#Partners :- Pavan Piratla, Nilo Rivera and Sandeep Ranade
#
#Please see attached ReadME document for operational instructions
#*******************************************************************************

# Formula: ( 2*(n-2^(log n))+1 ) / ( 2^(log n + 1) )
# Will use array as had problem with E and the above (the
# formula is correct and will work).

var label_array := [0, 1, 1, 3, 1, 3, 5, 7, 1, 3, 5, 7, 9, 13]
var label_name := ["0", "1", "01", "11", "001", "011", "101", "111",
                   "0001", "0011", "0101", "0111", "1001", "1011" ]

def supervisorFile() :any {
    return <file: `tree-sup.cap`>
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

def getLabel(num :int) :int {
    return (label_array[num])
}

def Supervisor() :any {
  var n := 0
  var v := null
  var pv := null
  var sv := null
  var ssv := null

  def join(w) :any {
    println(`supervisor_join`)
    if (n == 0) {
      w <- Setup(0, w, w, null, null, null)
      pv := w; v := w; sv := w; ssv := w
    } else {
      if ((getLabel(n)&2) == 0) {
        w <- Setup(n, sv, ssv, ssv, null, null)
        ssv <- setRightChild(w)
      } else {
        w <- Setup(n, sv, ssv, sv, null, null)
        sv <- setLeftChild(w)
      }
      sv <- setSucc(w)
      ssv <- setPred(w)
      pv := sv
      v := w
      sv := ssv
      ssv := ssv <- getSucc()
    }
    n := n+1
  }
  
  def leave(label, var pw, var sw, fw, var lcw, var rcw) :any {
    println(`supervisor_leave(v=$n-1, w=$label)`)
    def w := label
    if (n > 0) {     
      if (n == 1) {      
        pv := null; v := null
        sv := null; ssv := null
        n := n-1
      } else {
        #remove the node v from the tree
        if ((getLabel(n - 1) & 2 ) == 0){    
            sv <- setRightChild(null)
        } else {    
            pv <- setLeftChild(null)
        }
          
        var u := 0
    
        pv <- setSucc(sv)
        sv <- setPred(pv)
          
        when (pw, sw, lcw, rcw) -> done(r1, r2, r3, r4) :any  {    

          if (pw == v) { 
            pw := pv 
          }
         
          if (sw == v) {
            sw := sv
          }
      
          if (lcw == v) {
            lcw := null
          }

          if (rcw == v) {
            rcw := null
          }
        
          # move v into position of w
          #if (v != w) {
          if (label != (n-1)) {
            v <- Setup(label, pw, sw, fw, lcw, rcw)
            pw <- setSucc(v)
            sw <- setPred(v)
            if ((getLabel(n-1) & 2) == 0) {
                fw <- setRightChild(v)
            } else {
                fw <- setLeftChild(v)
            }
            if (lcw != null) {
                lcw <- setParent(v)
            }
            if (rcw != null) {
                rcw <- setParent(v)
            }
          }
          #update pointers
          if (pv == w) {
            pv := v
          }
          if (sv == w) {
            sv := v
          }
          ssv := sv
          sv := pv
          v := pv <- getPred()
          pv := pv <- getPredPred()  
          n := n-1                     
          println(`Success!`)
        } catch prob {     
          println("oops: " + prob)
        }
      }
    }
  }
  def remoteCalls {
    to Join(w) :any {
      join(w)
    }
    to Leave(label, pw, sw, fw, lcw, rcw) :any {
      println(`Disconnecting node index [$label]`)
      leave(label, pw, sw, fw, lcw, rcw)
    }
  }
  objIntoFile(remoteCalls, supervisorFile())
}  

# Make the available by a "captp://..." URI in a file
introducer.onTheAir()
Supervisor()

# Let the human operator know that the supervisor is ready.
println("Supervisor Ready.....")
interp.blockAtTop()



