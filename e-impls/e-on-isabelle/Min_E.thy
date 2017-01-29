(* Title: Min-E, the kernel of Kernel-E
   Author: Mark S. Miller
   Author: Sandeep Ranade
   Copyright 2004 under the terms of the MIT X License

   Based on BinExp.thy by
   M. Scott Doerrie
*)

(* Min-E is a subset of Kernel-E. The intent is that semantics of *)
(* the rest of Kernel-E can be specified by expansion to Min-E, *)
(* libraries written in Min-E, and externally linked *)
(* libraries. Specifically, Min-E leaves out *) 
(* guards/auditors/trademarking, "var", assignment, Slot exprs & patterns, *)
(* doc-comments, fully-qualified names, string literals, "loop", *)
(* "try-finally", and sealed problems. *)

(* Once we prove that a nested ObjectExpr is equivalent to a *)
(* __primEval of a top level one with an environment, *) 
(* then we can define the rest by building, in Min-E, an __eval *)
(* that takes a Kernel-E AST as an argument, audits it, transforms it *)
(* to Min-E, and loads it using __primEval. The actual __eval must be *)
(* semantically equivalent to this, but of course can be implemented *)
(* more directly. *)


theory Min_E = Main:;

(* Min-E's syntax *)

types eVarName = string;
types eMsgName = string;

datatype eExpr
  = IntLit int                           (* 37 *)
  | Float64Lit string                    (* 37.4 *)
  | CharLit char                         (* 'c' *)

  | NounExpr eVarName                    (* foo *) (* ::"&foo" *)
  | SeqExpr eExpr eExpr                  (* $1 \n $2 *) (* $1; $2 *)
  | MatchExpr eExpr ePattern             (* $1 =~ $2 *)
  | DefExpr ePattern eExpr               (* def $1 := $2 *)
  | HideExpr eExpr                       (* { $1 } *)
  | IfExpr eExpr eExpr eExpr             (* if ($1) { $2 } else { $3 } *)
  | CatchExpr eExpr ePattern eExpr       (* try { $1 } catch $2 { $3 } *)
  | CallExpr eExpr eMsgName "eExpr list" (* $1.foo($3...) *) 
                                         (* $1."$2"($3...) *)
  | ObjectExpr eScript

and ePattern
  = FinalPattern eVarName                (* foo *) (* ::"&foo" *)
  | IgnorePattern                        (* _ *)
  | SuchThatPattern ePattern eExpr       (* $1 ? $2 *)
  | ListPattern "ePattern list"          (* [ $1... ] *)
  | CdrPattern "ePattern list" ePattern  (* [ $1... ] + $2 *)

and eScript
  = Lambda eMatcher                      (* def _ match $1.$1 { $1.$2 } *)
  | VTable "(eMsgName * nat) ~=> eMethod" "eMatcher option"
                                         (* def _ { $1... } *)
                                         (* def _ { $1... $2 } *)
and eMethod
  = Method eMsgName ePattern eExpr       (* method $1 ($2...) { $3 } *)
                                         (* where the param list is *)
                                         (* represented as a ListPattern *)

and eMatcher
  = Match ePattern eExpr;                (* match $1 { $2 } *)

(* Runtime *)

types eAddr = nat;                       (* to be looked up in the store *)

types eID = nat;                         (* creation-time unique identity *)

  (* Things found in the store *)
datatype eValue

  (* PassByCopy *)

  = NullValue                            (* null *)
  | IntValue int                         (* 37 *)
  | Float64Value string                  (* 37.4 *)
  | CharValue char                       (* 'c' *)
  | BoolValue bool                       (* true, false *)
  | ConstList "eAddr list"               (* [1, 2] *)

  (* Stationary, as opposed to PassByCopy *)

  | Throw eID                            (* throw *)
  | OurEqualizer eID                     (* __equalizer *)
  | OurPrimEvaluator eID                 (* __primEval *)
  | SettableSlot eID eAddr               (* __makeVarSlot(37) *)

  | Instance "eID option" eScript eEnv
  (*         identity     srcAST  state *)

  (* A general escape for devices and external linkage *)
  | ExternalObj eID      string eEnv     (* Might be closely held *)
  (*            identity fqName state *)

and eEnv = Env "eVarName ~=> eAddr";

types eHeap = "eAddr ~=> eValue";
types eStore = "eAddr * eHeap";
  (*           nextAddr heap *)
datatype eState 
  = OkState    eStore eEnv
  | ErrorState eStore eAddr;
  (*                  excuse -- the thrown problem *)

consts 
  (* alloc takes a store and a value, and returns a pair of a new store *)
  (* containing this value, and the address of this value in the new *)
  (* store. *)
  alloc :: "eStore => eValue => (eStore * eAddr)";
primrec
  alloc: "alloc (nextAddr, heap) value 
  = ((nextAddr +1, heap(nextAddr |-> value)), nextAddr)";

  (* Looks up an addr in the store *)
consts
  get :: "eStore => eAddr ~=> eValue";
primrec
  get: "get (nextAddr, heap) addr = (heap addr)";


  (* applySubst does the context switch from caller to callee + the *)
  (* method lookup in the callee. *)
datatype eSubstResult
  = InstContext ePattern eExpr eEnv  (* If entering a matcher or method *)
  | PrimOk    eStore eAddr           (* If primitive call succeeds *)
  (*                 result *)
  | PrimError eStore eAddr           (* If we fail to enter an Instance, *)
  (*                 exAddr *)       (* or if a primitive call fails *)
consts
  applySubst :: "eStore => (eAddr *            (* recipient *)
                            eMsgName *         (* verb *)
                            eAddr list) =>     (* args *)
                 eSubstResult";

consts
  eEval :: "(eExpr 
             * eState
             * eState
             * eAddr option) set"
  eEvals :: "(eExpr list
              * eState
              * eState
              * eAddr list option) set"
  eMatch :: "(ePattern
              * eAddr
              * eState
              * eState
              * bool option) set"
  eMatches :: "(ePattern list
                * eAddr list
                * eState
                * eState
                * bool option) set";

inductive eEval eEvals eMatch eMatches
intros
  litInt[intro!]:"((alloc s0 (IntValue i)) = (s1, iAddr))
                  ==> ((IntLit i), 
                       (OkState s0 e0),
                       (OkState s1 e0),
                       (Some iAddr)) : eEval"
  litFloat64[intro!]:"((alloc s0 (Float64Value f)) = (s1, fAddr))
                      ==> ((Float64Lit f), 
                           (OkState s0 e0),
                           (OkState s1 e0),
                           (Some fAddr)) : eEval"
  litChar[intro!]:"((alloc s0 (CharValue c)) = (s1, cAddr))
                   ==> ((CharLit c), 
                        (OkState s0 e0),
                        (OkState s1 e0),
                        (Some cAddr)) : eEval"

  nounExprOk[intro!]:"((e0 name) = (Some addr))
                      ==> ((NounExpr name),
                           (OkState s0 (Env e0)),
                           (OkState s0 (Env e0)),
                           (Some addr)) : eEval"
  nounExprBad[intro!]:"((e0 name) = None)
                       ==> ((NounExpr name),
                            (OkState s0 (Env e0)),
                            (ErrorState s0 exAddr),
                            None) : eEval"
  seqExpr[intro!]:"[| (expr0, 
                       (OkState s0 e0),
                       (OkState s1 e1),
                       outcome1) : eEval;
                      (expr1,
                       (OkState s1 e1),
                       outState2,
                       outcome2) : eEval |]
                   ==> ((SeqExpr expr0 expr1),
                        (OkState s0 e0),
                        outState2,
                        outcome2) : eEval"
  matchBindExprOk[intro!]: "[| (expr0,
                                (OkState s0 e0),
                                (OkState s1 e1),
                                (Some specimen)) : eEval;
                               (patt1,
                                specimen,
                                (OkState s1 e1),
                                (OkState s2 e2),
                                (Some flag)) : eMatch; 
                               (alloc s2 (BoolValue b)) = (s3, bAddr) |]
                            ==> ((MatchExpr expr0 patt1),
                                 (OkState s0 e0),
                                 (OkState s3 e2),
                                 (Some bAddr)) : eEval"

  (* Scope goes left to right. Execution goes right to left. *)
  defExprOk[intro!]: "[| (patt1,
                          specimen,
                          (OkState s1 e0),
                          (OkState s2 e1),
                          (Some true)) : eMatch; 
                         (expr0,
                          (OkState s0 e1),
                          (OkState s1 e2),
                          (Some specimen)) : eEval |]
                      ==> ((DefExpr patt0 expr1),
                           (OkState s0 e0),
                           (OkState s2 e2),
                           (Some specimen)) : eEval"
  (* expr0 is evaluated in its own scope box *)
  hideExprOk[intro!]: "(expr0,
                        (OkState s0 e0),
                        (OkState s1 e1),
                        outcome1) : eEval
                       ==> ((HideExpr expr0),
                            (OkState s0 e0),
                            (OkState s1 e0),
                            outcome1) : eEval"

  (* expr1 is in expr0's successor scope. expr2 isn't *)
  ifTrueExprOk[intro!]: "[| (expr0,
                             (OkState s0 e0),
                             (OkState s1 e1),
                             (Some bAddr)) : eEval;
                            (get s1 bAddr) = (Some (BoolValue true));
                            (expr1,
                             (OkState s1 e1),
                             (OkState s2 e2),
                             outcome2) : eEval|]
                         ==> ((IfExpr expr0 expr1 expr2),
                              (OkState s0 e0),
                              (OkState s2 e0),
                              outcome2) : eEval"
  ifTrueExprBad[intro!]: "[| (expr0,
                              (OkState s0 e0),
                              (OkState s1 e1),
                              (Some bAddr)) : eEval;
                             (get s1 bAddr) = (Some (BoolValue true));
                             (expr1,
                              (OkState s1 e1),
                              (ErrorState s2 exAddr),
                              None) : eEval|]
                          ==> ((IfExpr expr0 expr1 expr2),
                               (OkState s0 e0),
                               (ErrorState s2 exAddr),
                               None) : eEval"
  ifFalseExprOk[intro!]: "[| (expr0,
                              (OkState s0 e0),
                              (OkState s1 e1),
                              (Some bAddr)) : eEval;
                             (get s1 bAddr) = (Some (BoolValue false));
                             (expr2,
                              (OkState s1 e0),
                              (OkState s2 e2),
                              outcome2) : eEval|]
                          ==> ((IfExpr expr0 expr1 expr2),
                               (OkState s0 e0),
                               (OkState s2 e0),
                               outcome2) : eEval"
  ifFalseExprBad[intro!]: "[| (expr0,
                               (OkState s0 e0),
                               (OkState s1 e1),
                               (Some bAddr)) : eEval;
                              (get s1 bAddr) = (Some (BoolValue false));
                              (expr2,
                               (OkState s1 e0),
                               (ErrorState s2 exAddr),
                               None) : eEval|]
                           ==> ((IfExpr expr0 expr1 expr2),
                                (OkState s0 e0),
                                (ErrorState s2 exAddr),
                                None) : eEval"
  catchExprOkOk[intro!]: "(expr0,
                           (OkState s0 e0),
                           (OkState s1 e1),
                           outcome1) : eEval
                          ==> ((CatchExpr expr0 patt1 expr2),
                               (OkState s0 e0),
                               (OkState s1 e0),
                               outcome1) : eEval"
  catchExprMatchOk[intro!]: "[| (expr0,
                                 (OkState s0 e0),
                                 (ErrorState s1 exAddr),
                                 None) : eEval;
                                (patt1,
                                 exAddr,
                                 (OkState s1 e0),
                                 (OkState s2 e2),
                                 (Some true)) : eMatch;
                                (expr2,
                                 (OkState s2 e2),
                                 (OkState s3 e3),
                                 outcome3) : eExpr |]
                             ==> ((CatchExpr expr0 patt1 expr2),
                                  (OkState s0 e0),
                                  (OkState s3 e0),
                                  outcome3) : eEval"
  catchExprNomatchOk[intro!]: "[| (expr0,
                                   (OkState s0 e0),
                                   (ErrorState s1 exAddr),
                                   None) : eEval;
                                  (patt1,
                                   exAddr,
                                   (OkState s1 e0),
                                   (OkState s2 e2),
                                   (Some false)) : eMatch;
                                  (expr2,
                                   (OkState s2 e2),
                                   (OkState s3 e3),
                                   outcome3) : eEval |]
                               ==> ((CatchExpr expr0 patt1 expr2),
                                    (OkState s0 e0),
                                    (OkState s3 e0),
                                    outcome3) : eEval"
  callInstExprOk[intro!]: "[| (expr0,
                               (OkState s0 e0),
                               (OkState s1 e1),
                               (Some recipientAddr)) : eEval;
                              (exprs1,
                               (OkState s1 e1),
                               (OkState s2 e2),
                               (Some argAddrs)) : eEvals;
                              ((applySubst s2
                                           (recipientAddr, msgName, argAddrs))
                               = (InstContext patt3 expr4 e3));
                              ((alloc s2 (ConstList argAddrs))
                               = (s3, argsAddr));
                              (patt3,
                               argsAddr, (* XXX wrong for matchers *)
                               (OkState s3 e3),
                               (OkState s4 e4),
                               (Some true)) : eMatch;
                              (expr4,
                               (OkState s4 e4),
                               (OkState s5 e5),
                               outcome5) : eEval |]
                           ==> ((CallExpr expr0 msgName exprs1),
                                (OkState s0 e0),
                                (OkState s5 e2),
                                outcome5) : eEval"
  callPrimExprOk[intro!]: "[| (expr0,
                               (OkState s0 e0),
                               (OkState s1 e1),
                               (Some recipientAddr)) : eEval;
                              (exprs1,
                               (OkState s1 e1),
                               (OkState s2 e2),
                               (Some argAddrs)) : eEvals;
                              ((applySubst s2
                                           (recipientAddr, msgName, argAddrs))
                               = (PrimOk s3 result3)) |]
                           ==> ((CallExpr expr0 msgName exprs1),
                                (OkState s0 e0),
                                (OkState s3 e2),
                                (Some result3)) : eEval"
  callPrimExprOkBad[intro!]: "[| (expr0,
                                  (OkState s0 e0),
                                  (OkState s1 e1),
                                  (Some recipientAddr)) : eEval;
                                 (exprs1,
                                  (OkState s1 e1),
                                  (OkState s2 e2),
                                  (Some argAddrs)) : eEvals;
                                 ((applySubst s2
                                              (recipientAddr,msgName,argAddrs))
                                  = (PrimError s3 exAddr)) |]
                              ==> ((CallExpr expr0 msgName exprs1),
                                   (OkState s0 e0),
                                   (ErrorState s3 exAddr),
                                   None) : eEval"
  objectExprOk[intro!]: "((alloc s0 (Instance (Some objAddr)
                                              script
                                              e0))
                          = (s1, objAddr))
                         ==> ((ObjectExpr script),
                              (OkState s0 e0),
                              (OkState s1 e0),
                              (Some objAddr)) : eEval"
  emptyExprsOk[intro!]: "([],
                          (OkState s0 e0),
                          (OkState s0 e0),
                          (Some [])) : eEvals"
  consExprsOk[intro!]: "[| (expr0,
                            (OkState s0 e0),
                            (OkState s1 e1),
                            (Some val)) : eEval;
                           (exprs1,
                            (OkState s1 e1),
                            (OkState s2 e2),
                            (Some vals)) : eEvals |]
                        ==> (expr0#exprs1,
                             (OkState s0 e0),
                             (OkState s2 e2),
                             (Some (val#vals))) : eEvals"
  finalPattOk[intro!]: "(scope0(name |-> specimen) = scope1)
                        ==> ((FinalPattern name),
                             specimen,
                             (OkState s0 (Env scope0)),
                             (OkState s0 (Env scope1)),
                             (Some true)) : eMatch"
  ignorePattOk[intro!]: "(IgnorePattern,
                          specimen,
                          (OkState s0 e0),
                          (OkState s0 e0),
                          (Some true)) : eMatch"
  stPattOk[intro!]: "[| (patt0,
                         specimen,
                         (OkState s0 e0),
                         (OkState s1 e1),
                         (Some true)) : eMatch;
                        (expr1,
                         (OkState s1 e1),
                         (OkState s2 e2),
                         (Some bAddr)) : eEval;
                        (get s1 bAddr) = (Some (BoolValue flag)) |]
                     ==> ((SuchThatPattern patt0 expr2),
                          specimen,
                          (OkState s0 e0),
                          (OkState s2 e2),
                          (Some flag)) : eMatch"
  listPattOk[intro!]: "[| (get s0 specimen) = (Some (ConstList specimens));
                          (patts0,
                           specimens,
                           (OkState s0 e0),
                           state1,
                           outcome1) : eMatches |]
                       ==> ((ListPattern patts0),
                            specimen,
                            (OkState s0 e0),
                            state1,
                            outcome1) : eMatch"
  emptyPattsOk[intro!]: "([],
                          [],
                          (OkState s0 e0),
                          (OkState s0 e0),
                          (Some true)) : eMatches"
  consPattsOk[intro!]: "[| (patt,
                            sp0,
                            (OkState s0 e0),
                            (OkState s1 e1),
                            (Some true)) : eMatch;
                           (patts1,
                            sps1,
                            (OkState s1 e1),
                            state2,
                            outcome2) : eMatches |]
                        ==> (patt0#patts1,
                             sp0#sps1,
                             (OkState s0 e0),
                             state2,
                             outcome2) : eMatches";
