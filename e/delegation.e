#!/usr/bin/env e

/**

This file shows off one new idea: inheritance, and teases with others:
quasi-literals, quasi-patterns, and hygienic syntactic macros.  The
quasi stuff is used to define the syntactic sugar in which the
inheritance construct is expressed.  (I believe the inheritance ideas
can be easily followed even if the quasi stuff remains mysterious, and
vice versa.)

Inheritance is done purely by static object composition and message
delegation.  The result perfectly emulates the standard inheritance
semantics shared by Smalltalk, single-inheritance-C++, and Java.
In all these, an object is composed by instantiating an ancestry chain
of classes.  Let's refer to the part of the object that comes from one
of these classes as a slice.

To rebuild inheritance out of finer-grained, more flexible material,
we model each slice by a separate object.  The bottom slice represents
the aggregate object, and all objects in the chain point to this
bottom object with their instance variable 'self'.  Each object
(except the top one) points to the object immediately above it with
its instance variable 'super'.  Should any object not understand a
message it receives, it forwards the message up the chain.

This lets us address a major concern: We like to say that capabilities
are equivalent to object references in a pure object system.  However,
capability analysis never knew what to say about inheritance.  In Java
and E, inheritance can happen between classes authored by mutually
suspicious programmers.  The resulting object could then be thought of
as composed of mutually suspicious slices.  However, we have no tools
for thinking about mutual suspicion within an object.  This expansion
reduces the issue to a previously solvable problem.

Of course, once E wants to compete with other languages on speed, we
don't want to implement inheritance this way.  We know from Smalltalk
and C++ how to implement the standard inheritance pattern efficiently.
If we're confident the semantics are equivalent, we'd have the
optimizer recognize the expansion of the standard pattern, change the
aggregate to live in one allocation record, and short-circuit the
message dispatch search by aggregating the vtables.  By generalizing
the optimizer, other static delegation patterns can share many of
these benefits.  That's just the kind of generalized transparent
optimization that Scheme-like languages are so good at.

*/


/**

<defmacro> ::=

    "defmacro" <pattern> <anaphora> "{" <expr> "}"

<anaphora> ::=

    [ "[" [<ident> ("," <ident>)* ] "]" ]


A macro is introduced by the defmacro form.  Within the scope of the
macro definition, parse-trees that match the pattern are replaced by
the result of evaluating the body expression.  All variable names in
the resulting value must either be of the form "ident$n", or be
declared in the optional list of anaphoric variable names following
the pattern.

For each macro application, a unique number is cooked up and
substituted for the "n" in "ident$n", to prevent collisions with
variables in the expansion context.  These are the hygienic names.
Anaphoric variable names are the opposite of hygienic ones, these are
intended to capture or be captured by variable names in the expansion
scope.  (XXX Even with the explicit declaration, given cross-module
importing, this is a security point danger.  Should probably use the
true hygiene rules as understood by schemers.  Need to revisit.)

We see below a new convenience for expressing patterns and
expressions: quasi-quoted (or back-quoted) strings.  Between the
quasi-quotes is a parsable E program text that evaluates to the
corresponding parse tree.  But with two differences:

    1) "$identifier" or "${expr}" evaluate in the current lexical
    scope, and the resulting value is plugged into the resulting parse
    tree in that position.

    2) A pattern quasi-string can additionally contain "@identifier"
    or "@{identifier}", defining these names as parameter variables of
    the macro form.  When the pattern is matched against an argument
    parse tree, if the match succeeds these parameters are bound to
    the corresponding parts of the argument parse tree.

*/


#
# Example: Simple point as a class-like example without inheritance:
#

define Point(x, y) {
    define self {
	to getX {x}
	to getY {y}
    }
}


#
# Example: Redefining "while" as a macro.
#
# While the condition is true, keep evaluating the body
#

defmacro e`while (@cond) {@body}` [break, continue] {

    e`escape break {
        loop {
            if ($cond) {
                escape continue {$body}
            } else {
                break()
            }
        }
    }`
}


#
# Each time a message is sent to this value, evaluate body and forward
# the message to body's result
#

defmacro e`delegate {@body}` {

    e`match [verb$n, args$n] {
        $body call(verb$n, args$n)
    }`
}


#
# Example: lazy evaluation.  "->" is read "expands to".
#

define lazy(myThunk) {
    define myDone := false
    define myValue := null
    define self {
        to toString() {
            if (!myDone) {
                "lazing"
            } else {
                myValue toString
            }
        }
        delegate {
            if (!myDone) {
                myValue := myThunk()
                myDone := true
                myThunk := null
            }
            myValue
        }
    }
}

->

define lazy {
    to run(myThunk) {
        define myDone := false
        define myValue := null
        define self {
            to toString() {
                if (!myDone) {
                    "lazing"
                } else {
                    myValue toString
                }
            }
            match [verb$3, args$3] {
                (
                    if (!myDone) {
                        myValue := myThunk()
                        myDone := true
                        myThunk := null
                    }
                    myValue
                ) call(verb$3, args$3)
            }
        }
    }
}

#
# z represents the result of calculating with x and y, but the
# calculation wont happen until the first time z gets used.
#

define z := lazy ( def _() {hairyCalculation(x, y)} )



#
# Used like 'define param (param...) {body}' to define an object
# constructor.  This acts like the 'define' form, except that 'body'
# has 'self' in scope.  When invoked with '(arg...)', 'self' will be
# bound to the object 'body' evaluates to.  When invoked with
# 'inherit(self, arg...)', 'self' will be bound to the passed in self
# argument.
#

defmacro e`class @name (@param...) {@body}` [self] {
    e`define $name {
	to inherit(self, $param...) {
	    $body
	}
	//XXX not params, but pass-thru simple names
	to ($param...) {
	    define self$n := $name inherit(self$n, $param...)
        }
    }`
}


###################
#
# Inheritance example.  Shape is like a non-abstract, non-final root
# class.  Ie, it has no super, it can be directly instantiated, and it
# can be indirectly instantiated via an object that inherits from it.
# This example shows off passed-in and calculated super state
# (myBounds and myArea respectively), a method that calls a method to
# be provided by the sub (isInside), and a to be method overridden by
# the sub while still being invokable by the sub via 'super'
# (isOutside).
#
# A non stupid example would be appreciated.
#
###################

class Shape(myBounds) {

    define myArea := myBounds width * myBounds height

    define slice {
        to isInside(pt) {
            myBounds isInside(pt) && self reallyInside(pt)
        }
        to isOutside(pt) {
            myBounds isOutside(pt)
        }
        to area() { myArea }
    }
}


#
# Circle is like a non-abstract, non-final subclass of Shape.  It
# differs from a root class in two ways:
#
#   1) The line defining 'super' to be an instance of Shape.  This
#   call also tells Shape to bind 'self' to whatever it is bound to in
#   Circle (remember, Circle can be further inherited from).  Notice
#   that the super construction argument, 'bounds', is calculated in
#   this constructor.  After defining super one can have
#   initialization code involving super, as long as it only involves
#   parts of super that don't depend on self.
#
#   Note: Before construction finishes, "self" is a DEFERRED Promise.
#   Synchronous calls on it will fail while in this state, but
#   asynchronous sends are fine.  The latter only get processed once
#   the chain has been fully constructed.  This is much cleaner than
#   the construction semantics of most other languages.
#
#   2) The 'delegate {super}' at the end of the methods section causes
#   any messages a Circle doesn't understand to be forwarded up to the
#   parent Shape.
#

class Circle(myCenter, myRadius) {

    define bounds := Bounds(myCenter x - radius,
                            myCenter y - radius,
                            myCenter x + radius,
                            myCenter y + radius)

    define super := Shape inherit(self, bounds)

    define slice {

        to reallyInside(pt) {
            radius**2 >= (pt x)**2 + (pt y)**2
        }
        to isOutside(pt) {
            super isOutside(pt) || !self reallyInside(pt)
        }
        delegate {super}
    }
}


#
# Expanded
#

define Shape dispatch {

    to inherit (self, myBounds) {
	define myArea := myBounds width * myBounds height

	define slice {
	    to isInside(pt) {
		myBounds isInside(pt) && self reallyInside(pt)
	    }
	    to isOutside(pt) {
		myBounds isOutside(pt)
	    }
	    to area() { myArea }
        }
    }

    to run(myBounds) {
        define self$4 := Shape inherit(self$4, myBounds)
    }
}


define Circle {

    to inherit (self, myCenter, myRadius) {
	define bounds := Bounds(myCenter x - radius,
	                        myCenter y - radius,
                                myCenter x + radius,
                                myCenter y + radius)

	define super := Shape inherit(self, bounds)

	define slice {
	    to reallyInside(pt) {
		radius**2 >= (pt x)**2 + (pt y)**2
	    }
	    to isOutside(pt) {
		super isOutside(pt) || !self reallyInside(pt)
	    }
	    match [verb$5, args$5] {
		super call(verb$5, args$5)
	    }
	}
    }

    to run(myCenter, myRadius) {
        define self$4 := Circle inherit(self$4, myCenter, myRadius)
    }
}




