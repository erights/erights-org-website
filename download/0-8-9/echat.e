#!/usr/bin/env e

#   The contents of this file are subject to the Mozilla Public
#   License Version 1.1 (the "License"); you may not use this file
#   except in compliance with the License. You may obtain a copy of
#   the License at
#   http://www.skyhunter.com/marcs/securit-echat-license.html Software
#   distributed under the License is distributed on an "AS IS" basis,
#   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
#   License for the specific language governing rights and limitations
#   under the License.

# The Original Code is The SecurIt-Echat Program.

# The Initial Developer of the Original Code is Marc
# Stiegler. Portions created by Marc Stiegler are Copyright (C) Marc
# Stiegler. All Rights Reserved.

# **********

# set up tracing; stub out all the printing for operational version
define traceln(str) : any {
    # println(str)
    str
}

# set up imports
define swing__uriGetter := <import:javax.swing.*>
define awt__uriGetter := <import:java.awt.*>
define JPanel__quasiParser := <import:org.erights.ex.swing.JPanel__quasiParser>


# Ensure the user knows if he's using a clear, unencrypted connection
traceln(introducer negotiable)

define Title := if (introducer negotiable == ["3DES_SDH_M"]) {
    "Secure EChat"
} else {
    <swing:JOptionPane> showMessageDialog(null,
    "You are using DaffE, so you'll be chatting in the clear.
    To be secure, use E instead.",
    "Unencrypted DaffE Session",
    <swing:JOptionPane> WARNING_MESSAGE)
    "EChat"
}

introducer onTheAir
traceln(introducer)

# return the object represented by the URI
define getObjectFromURI(uri) : any {
    introducer sturdyFromURI(uri) liveRef
}

define makeURIFromObject(obj) : any {
    introducer sturdyToURI(sturdyRef(obj))
}

# return the friend file
define findFriendFile(chatWin) : any {
    define dialog := <awt:FileDialog> new(chatWin, "Select a Friend")
    dialog show
    define path := dialog.file
    if (path != null) {
        path := dialog.directory + path
    }
    <file: path>
}

# return a file to be saved
define requestSaveFile(chatWin) : any {
    define dialog := <awt:FileDialog> new(chatWin,
    "Save File with Your Name",
    <awt:FileDialog> SAVE)
    dialog show
    define addressName := dialog.file
    if (addressName != null) {
        addressName := dialog.directory + addressName
    }
    <file: addressName>
}

# method that writes out the URI for your echat system's communication
# interface
define offerMyAddress(file, uri) {
    file.text := uri
}

define set1LineComponentParameters(component) {
    component.preferredSize := <awt:Dimension> new (150,25)
    component.maximumSize := <awt:Dimension> new(1000,25)
    component.alignmentX := 0.5
}

define chatUIMaker new(chatController) : any {
    # Lay out the chat window, create its components
    define chatWin := <swing:JFrame> new(Title)
    define chatPane := chatWin.contentPane
    define border := <swing:BoxLayout> new(chatPane,1)
    chatPane.layout := border
    traceln("p1 ui made");
    define windowListener {
        to windowClosing(event) {
            chatController leave
            traceln("trying to exit")
            interp continueAtTop
        }
        match _ {}
    }
    chatWin addWindowListener(windowListener)
    traceln("p2 ui made");

    # make a button that calls the chatController
    define newButton(labelText, verb) : any {
        # define button := <swing:JButton> new(labelText)
        define button := E call(<swing:JButton>, "new(String)",[labelText])
        traceln("made button")
        set1LineComponentParameters(button)
        define buttonListener {
            to actionPerformed(event) {
                E call(chatController, verb, [])
            }
        }
        button addActionListener(buttonListener)
        traceln("button being returned")
        button
    }

    # setNameButton
    define setNameButton := newButton("Set Your Name", "setMyName")

    # offerChatButton
    define offerChatButton := newButton("Offer Chat", "offerSelf")
    offerChatButton.enabled := false

    # findFriendButton
    define findFriendButton := newButton("Find Friend", "findFriend")
    findFriendButton.enabled := false

    # chatScroller that holds chatTextArea
    define chatScroller := <swing:JScrollPane> new
    chatScroller.maximumSize := <awt:Dimension> new(2000,1000)
    chatScroller.preferredSize := <awt:Dimension> new(250,80)

    # chatTextArea
    define chatTextArea := <swing:JTextArea> new
    chatTextArea.lineWrap := true
    chatScroller.viewport add(chatTextArea)

    # nextMessageBox
    define nextMessageBox := <swing:JTextField> new("Type your message here",30)
    set1LineComponentParameters(nextMessageBox)
    chatPane add(nextMessageBox)
    traceln("p3 ui buildt");

    # sendMessageButton
    define sendMessageButton := newButton("Send", "send")
    sendMessageButton.enabled := false

    chatPane add(JPanel`
    $setNameButton
    $offerChatButton $findFriendButton
    $chatScroller.Y
    $nextMessageBox
    $sendMessageButton`)

    chatWin pack
    chatWin show

    define chatUI {
        to getChatWin           : any { chatWin }
        to getNameButton        : any { setNameButton }
        to getOfferChatButton   : any { offerChatButton }
        to getFindFriendButton  : any { findFriendButton }
        to getChatTextArea      : any { chatTextArea }
        to getNextMessageBox    : any { nextMessageBox }
        to getSendMessageButton : any { sendMessageButton }
    }
}

# facet of chatController sent to other chatter with only appropriate
# messages
define chatReceiverMaker new(chatController) : any {
    define chatReceiver {
        to receive(message) { chatController receive(message) }
        to receiveFriend(friend, name) : any {
            chatController receiveFriend(friend, name)
        }
        to friendIsLeaving { chatController friendIsLeaving }
        to revoke { chatController := null }
    }
}

define chatControllerMaker new : any {
    define chatController := {
        define chatUI := chatUIMaker new(chatController)
        define myChatReceiver := chatReceiverMaker new(chatController)
        define myName := null
        define myFriend := null
        define myFriendName := null
        define myAddressFile := null
        traceln("initialized chatController");
        define showMessage(senderName, message) {
            chatUI.chatTextArea append(senderName +" says:\t"+ message + "\n")
        }
        define showDebug(message) {
            #chatUI.chatTextArea append("Debug: " + message + "\n")
        }
        define chatController {
            # transmitting functions
            to send {
                define nextMessage := chatUI.nextMessageBox.text
                chatUI.nextMessageBox.text := ""
                traceln("next message" + nextMessage)
                myFriend <- receive(nextMessage)
                showMessage(myName, nextMessage)
            }
            to setMyName {
                myName := <swing:JOptionPane> showInputDialog(
                "Please give me your name for this chat session");
                if (myName != null) {
                    chatUI.nameButton.label := myName
                    chatUI.nameButton.enabled := false
                    chatUI.offerChatButton.enabled := true
                    chatUI.findFriendButton.enabled := true
                }
            }
            to offerSelf {
                myAddressFile := requestSaveFile(chatUI.chatWin)
                if (myAddressFile != null) {
                    offerMyAddress(myAddressFile,
                    makeURIFromObject(myChatReceiver))
                }
            }
            to leave {
                if (myAddressFile != null) {
                    myAddressFile delete
                }
                myFriend <- friendIsLeaving
                chatController disconnect("is being left")
            }
            to receive(message) {
                showMessage(myFriendName, message)
            }
            to receiveFriend(friend, name) : any {
                traceln("receiveFriend")
                myFriend := friend
                myFriendName := name
                chatUI.sendMessageButton.enabled := true
                chatUI.offerChatButton.enabled := false
                chatUI.findFriendButton.enabled := false
                chatUI.chatTextArea append(myFriendName + " has arrived\n")
                friend <- whenBroken(define observer(prom) {
                    chatController disconnect("disconnected")
                })
                traceln("received")
                myName
            }
            to findFriend {
                define file := findFriendFile(chatUI.chatWin)
                if (file != null) {
                    define friendURI := file.text
                    showDebug("uri " + friendURI)
                    define friend := getObjectFromURI(friendURI)
                    showDebug("obj " + friend)

                    when (friend <- receiveFriend(myChatReceiver,
                    myName))-> done(friendName) {
                        showDebug("won against all odds")
                        chatController receiveFriend(friend, friendName)
                    } catch problem {
                        showDebug("clobbered: " + problem)
                        chatController disconnect("is unreachable")
                    }

                    showDebug("sent me")
                }
            }
            to friendIsLeaving {
                chatController disconnect("is leaving")
            }
            to disconnect(desc) {
                chatUI.sendMessageButton.enabled := false
                if (myFriendName == null) {
                    myFriendName := "the friend"
                }
                chatUI.chatTextArea append(myFriendName + " " + desc + "\n")
                myFriend := null
                myFriendName := null
                myChatReceiver revoke
            }
        }
    }
}

define controller := chatControllerMaker new
traceln(interp.args)
interp blockAtTop

