My goal is to get E running using hte Squeak VM.  When we talked at
Hackers, we flipped back and forth between that and something like
adding more of E features to Squeak.  I would like to focus on getting
E running.  To that end, here is the current snapshot.  The current
problem I'm running into is getting source information and debugging
to work.

To run all this, get the current E, install it, then add these
properties to eprops.txt:

e.enable.smalltalk-return=true
e.enable.explicit-result-guard=false

The attached files are for an up-to-date 3.8 image.  Load the Tools
files first, which among other things contains manually ordered minor
enhancements to the Scanner and Parser (to not choke on "_").

The other file should have all of the E on Squeak implementation that
goes in Smalltalk.

The E side of the code is in the slang directory (the other two are
just demo/test code).  The converter is BinFrames (an evolved name
6that I will rename next time :-) .  At the bottom are various
incantations far the E interpreter to parse and generate .slang files
for various directory trees.  You would need to tweak those to reflect
your directory structure.

The notes files starts with a few incantations in Smalltalk to load
the compiled-E world.  The first set require that slang/system
directory be entirely compiled.  Right now, BootScopeMaker class
defines defaultRoot, which is where Squeak will go looking for
compiled files (liek the base of the class path in Java).

Let me know when you are starting to actually unpack this, and I will
try to be available to help walk through the inevitable gap in thie
early documentation :-)

The test module for Chris Hibbert's marketMaker stuff (from the "if"
directory) fails because something about 'int' changed in a recent E
release.  Rather than try to fix that, I use his example to try to
figure out how to get debugging working in Squeak.  To get source
positions, Squeak now attempts to parse the decompiled source (I have
no idea why).  The problem is that E generates symbols that will work
in aparse tree, but not as Smalltalk source.  If I could either
provide source positions (but I don't know how to drive that mechanism
in Smalltalk) or get it to not try decompiling, it would work a lot
better :)
