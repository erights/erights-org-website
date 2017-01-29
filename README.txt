Preliminary Open Source Distribution of the E Distributed Programming Language


To install on Win95:

Unzip e.zip into C:\e

Run C:\e\Setup.bat

This will install the EBash icon in your start menu "Programs\erights.org".

Find and launch this icon.  It is a GNU bash shell with the environment
set up for running E.  In this shell, you can type:

1) "e" to run the E interpreter interactively

2) "e filename args..." to interpret an E program.  Alternatively, you
can put "#!/bin/e" at the top of your E program, in which case you can
just say "filename args..."

3) "elmer" to use a swing-based gui interface to the E interpreter.
Try typing "? 2 + 3" and hitting return.

Elmer acts like a normal Notepad-like text editor until you begin a
line with a question mark (E's prompt).  Lines beginning with a
question mark are special, as are lines beginning with a ">" that come
after a special line.  Hitting return on a special line invokes the E
interpreter, much as typing "e" to EBash does.  See
C:\e\src\doc\e\Vector.updoc for more.
