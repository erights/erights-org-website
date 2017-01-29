#!/usr/bin/env rune

rune(["hyper-ring.e", "foo", def foo])
rune(["hyper-ring.e", "bar", def bar])
interp.waitAtTop(bar)
interp.waitAtTop(foo <- get(1) <- joinRing(bar))

def printRing() :void {
    println("--")
    interp.waitAtTop(bar <- get(1) <- printOn(stdout))
}
printRing()

rune(["hyper-ring.e", "zip", def zip])
interp.waitAtTop(zip <- get(1) <- joinRing(bar))
printRing()

rune(["hyper-ring.e", "zap", def zap])
interp.waitAtTop(zap <- get(1) <- joinRing(bar))
printRing()

rune(["hyper-ring.e", "top", def top])
interp.waitAtTop(top <- get(1) <- joinRing(bar))
printRing()

interp.waitAtTop(zap <- get(1) <- leaveRing())
printRing()

interp.waitAtTop(zip <- get(1) <- leaveRing())
printRing()

interp.waitAtTop(foo <- get(1) <- leaveRing())
printRing()

interp.waitAtTop(top <- get(1) <- leaveRing())
printRing()

interp.waitAtTop(bar <- get(1) <- leaveRing())
printRing()


