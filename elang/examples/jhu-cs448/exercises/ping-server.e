#!/usr/bin/env rune

# Copyright 2004 Mark S. Miller & Sandeep Ranade under the terms of the 
# MIT X license found at http://www.opensource.org/licenses/mit-license.html ..

introducer.onTheAir()

/**
 * In our design, the pingServer uses a handshake to create a separate
 * per-client facet of the server (the pinger) for serving ping
 * messages from that client.
 * <p>
 * We have a separate handshake message, so that we only need to use
 * the uri-file technique for <i>initial</i> connectivity. Once the
 * client has a live reference to the server, it use the handshake
 * message to give the server a live reference back to the client.
 * <p>
 * The creation of the separate pinger allows the pingServer to
 * maintain separate per-client state, which here is just the
 * reference to the particular client.
 */
def pingServer {

    /**
     * Return a per-client pinger that, every time it's ping()ed, will
     * pong() the given pongClient.
     */
    to handshake(pongClient) :any {
        def pinger {
            to ping(count) :void {
                println(`ping: $count`)
                pongClient <- pong()
            }
        }
        return pinger
    }
}

# Make the pingServer available by a "captp://..." URI in a file
def sr := makeSturdyRef.temp(pingServer)
def uri := introducer.sturdyToURI(sr)
<file:~/Desktop/ping-server.cap>.setText(uri)

# Let the human operator know that the server & the file is ready.
println("waiting...")

interp.blockAtTop()
