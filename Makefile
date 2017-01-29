# This Makefile is hereby placed in the public domain.
#
# Makefile for $(TOP)/doc
# Note that we now depend on Java JDK >= 1.3

default: all

TOP=..

include $(TOP)/src/build/makerules.mk

FULL_JAVA_SOURCES=c:/jdk1.4/src
SWT_SOURCES=c:/installers/java/eclipse/eclipse2/eclipse/src
SRCPATH=$(TOP)/src/jsrc$(SEP)$(FULL_JAVA_SOURCES)$(SEP)$(SWT_SOURCES)



# all: buttons ode javadocs tarballs
all: buttons edocs tarballs

buttons:
	$(STLE) $(TOP)/src/esrc/scripts/ButtonPointer.e $(TOP)/doc

ode:
	(cd elib/capability/ode; ./compose.e)


edocs: _edoclet edoc_packages edoc_ser _javadoc fix_javadoc tarballs

_edoclet:
	find $(TOP)/src/jsrc/com/combex/e/edoc -name '*.java' > files.tmp
	$(TOOLCOMPILE) @files.tmp

edoc_packages:
	(cd $(TOP)/src/jsrc; find . -name '*.java') \
		> files.tmp
	(cd $(TOP)/src/safej; find . -name '*.safej') \
		>> files.tmp
	(cd $(TOP)/src/jsrc/org/erights/e/meta; find . -name '*.java') \
		>> files.tmp
	# (cd $(SWT_SOURCES); find org/eclipse/swt -name '*.java') \
	#	>> files.tmp
	grep -v "/CVS/" files.tmp | grep -v "/cya/" \
		| sed 's@^\./@@' | sed 's@/[^/]*$$@@' \
		| sort | uniq | sed 's@/@.@g' \
		> packages.tmp

edoc_ser:
	-rm -rf $(TOP)/edoc.ser
	$(JAVADOC) -J-Xmx256m \
		-docletpath "$(RUN_PATH)" \
		-doclet com.combex.e.edoc.DocSerializer \
		-private \
		-sourcepath "$(SRCPATH)" \
		-ser $(TOP)/edoc.ser \
		@packages.tmp


HEADER=<a href=\"{@docroot}/../index.html\"  target=\"_top\"><img src=\"{@docroot}/../images/e-lambda.gif\" border=\"0\"></a>
BOTTOM=<center>comments? <i><a href=\"mailto:bugs@erights.org\">bugs@erights.org</a></i> or <a href="http://www.blindpay.com/crit-me-now.cgi"><img src="{@docroot}/../images/cmn.gif" width="98" height="21" border="0" align="middle"></a></center>

ER=org.erights.e

_javadoc:
	-rm -rf javadoc
	mkdir -p javadoc
	$(JAVACMD) -Xmx256m \
		-cp "$(RUN_PATH)$(SEP)$(JAVA_HOME)/lib/tools.jar" \
		-De.safej.bind-var-to-varName=true \
		-Djava.library.path=$(TOP)/src/bin/$(PLATDIR) \
		com.combex.e.edoc.EDocMain \
		-unser $(TOP)/edoc.ser \
		-tamedir $(TOP)/src/safej \
		-use \
		-version \
		-author \
		-splitindex \
		-windowtitle 'ELib API' \
		-doctitle 'ELib API' \
		-group "ELib: Using E from Java" \
	"$(ER).elib.*" \
		-group "ELib Support" \
	"$(ER).develop.*:$(ER).extern.*" \
		-group "(Somewhat) Tamed Core Java Libraries" \
	"java.*" \
		-group "Pluribus: Cryptographic Distributed Capabilities" \
	"net.vattp.*:net.captp.*" \
		-group "ELang: Implementing The E Language" \
	"$(ER).elang.*" \
		-group "SWT - The Standard Widget Toolkit" \
	"org.eclipse.swt*" \
		-group "Swing" \
	"$(ER).ui.*:com.zooko.tray*:java.awt*:javax.swing*:javax.accessibility*" \
		-group "Text & Symbol Processing" \
	"org.capml.*:org.quasiliteral.*:com.skyhunter.ex.swing.text.*" \
		-group "Third Party Text & Symbol Processing Tools" \
	"org.apache.oro.text.regex:antlr*" \
		-group "Experimental Protocol Designs" \
	"net.ertp*:net.caprest*" \
		-group "Meta: Sugaring and Deflecting Java Classes" \
	"$(ER).meta.*" \
		-header "$(HEADER)" \
		-bottom "$(BOTTOM)" \
		-d javadoc

fix_javadoc:
	$(STLE) -De.interp.print-timing=true \
		$(TOP)/src/esrc/scripts/fixdoc.e javadoc

tarballs:
	tar czf download/javadoc.tar.gz javadoc

clean clobber: clobber-javadocs

clobber-javadocs:
	-rm -rf javadoc
