Copyright 2004 Kevin Chung, Keith Binder under the terms of the
MIT X license found at http://www.opensource.org/licenses/mit-license.html

Theory of Network Communication - 600.348
readme.txt - Final Project
deBruijn Graph & Hypercube combination
Due: 12/17/04

To initialize tree nodes, type:
  rune dBhc_combo.e [node]

For example, to start up a 3 node tree, type:
  rune dBhc_combo.e 1
  rune dBhc_combo.e 2
  rune dBhc_combo.e 3

Then on a separate cygwin console, you can connect to any of the nodes
as follows:

rune

introducer.onTheAir()
def uri1 := <file:dBhc-1.cap>.getText()
def d1 := introducer.sturdyFromURI(uri1).getRcvr()
def uri2 := <file:dBhc-2.cap>.getText()
def d2 := introducer.sturdyFromURI(uri2).getRcvr()
def uri4 := <file:dBhc-4.cap>.getText()
def d4 := introducer.sturdyFromURI(uri4).getRcvr()

def uri3 := <file:dBhc-3.cap>.getText()
def d3 := introducer.sturdyFromURI(uri3).getRcvr()
def uri5 := <file:dBhc-5.cap>.getText()
def d5 := introducer.sturdyFromURI(uri5).getRcvr()

d1 <- Join(1)
d2 <- Join(2)
d4 <- Join(4)

d4 <- Restructure(4)

d3 <- Join(3)
d5 <- Join(5)
d2 <- Broadcast("Broadcasted message", null)
d2 <- Unicast("Unicasted message", null)
d4 <- Unicast("Unicasted message", null)

d3 <- Leave(3)

----------

1. DEBRUIJN DESIGN

    [blank]                                    1
     /   \                                   /   \
    0     1             converts to         2     3
   / \   / \                               / \   / \
  00 10 01 11                             4   5 6   7
 /                                       /
000 ...                                 8  ...

      1
     /
    2   (3)
   /     ^
  4 - -> |

------------

(some hypercubic edge checks)
000 vs  (8)
100     (9)
010     (10)
110     (11)
001     (12)
101     (13)
011     (14)
111     (15)

8 -> 9, 10, 12
9 -> 8, 11, 13
10 -> 8, 11, 14
11 -> 9, 10, 15
12 -> 8, 13, 14
13 -> 9, 12, 15
14 -> 10, 12, 15
15 -> 11, 13, 14

We have designed the nodes to be numbered according to deBruijn specs,
but with an easier base 10 approach.  For instance, the numbers
[blank], 0, 1, 00, 01, 10, 11, 000 ... would correspond to 1, 2, 3, 4,
5, 6, 7, and 8.  We simplify the deBruijn number by appending the bits
to the left of a DBNumber.  For instance, the node 100010110 is really
'10' merged with the DBnumber '0010110'.  All we are concerned about
is really the '10', and the remainder of the number is for aesthetics.

In our deBruijn base 2 to 10 conversion, we append a '1' to the right
of the number, and calculate the base 10 representation left-to-right.
For instance, '01' -> '011', and in left-to-right, it is 0 + 2*1 + 4*2
= 6.

Parent-child relationships can be found as follows.  To find the
parent of a node A, divide it by 2.  To find the children of a node A,
multiply it by 2, and add 0 for the left child and 1 for the right
child.

2. HYPERCUBIC DESIGN

According to the numbering system above, our hypercube cross-edges are
much easier to realize.  To compare two nodes to see if they are on
the same level, compare the logs of the numbers (i.e. log(4) = log(7)
= 2).  To check for hypercubic edges between two nodes on the same
level, we can do a bit check for a one-bit difference.

3. UNICAST

Unicast is implemented as follows.  A node will unicast to all
neighbors including:
- 1 parent
- 2 children
- d hypercubic siblings, where d = # of bits represented by node
