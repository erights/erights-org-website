Start a fileserver as follows:
  rune fileSvr.e-awt name

For example, a 4-fileserver could be initialize as follows.
They should be run on the same directory

rune fileSvr.e-awt A
rune fileSvr.e-awt B
rune fileSvr.e-awt C
rune fileSvr.e-awt D

Start a client as follows:
  rune fileClt.e-awt name

For example, start a client to connect to the fileserver B.
The client should be run on the same directory as the fileservers

rune fileClt.e-awt B
