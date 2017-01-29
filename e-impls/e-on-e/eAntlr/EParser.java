// $ANTLR 2.7.4: "e.g" -> "EParser.java"$

import antlr.TokenBuffer;
import antlr.TokenStreamException;
import antlr.TokenStreamIOException;
import antlr.ANTLRException;
import antlr.LLkParser;
import antlr.Token;
import antlr.TokenStream;
import antlr.RecognitionException;
import antlr.NoViableAltException;
import antlr.MismatchedTokenException;
import antlr.SemanticException;
import antlr.ParserSharedInputState;
import antlr.collections.impl.BitSet;
import antlr.collections.AST;
import java.util.Hashtable;
import antlr.ASTFactory;
import antlr.ASTPair;
import antlr.collections.impl.ASTArray;

public class EParser extends antlr.LLkParser       implements ETokenTypes
 {

protected EParser(TokenBuffer tokenBuf, int k) {
  super(tokenBuf,k);
  tokenNames = _tokenNames;
  buildTokenTypeASTClassMap();
  astFactory = new ASTFactory(getTokenTypeToASTClassMap());
}

public EParser(TokenBuffer tokenBuf) {
  this(tokenBuf,2);
}

protected EParser(TokenStream lexer, int k) {
  super(lexer,k);
  tokenNames = _tokenNames;
  buildTokenTypeASTClassMap();
  astFactory = new ASTFactory(getTokenTypeToASTClassMap());
}

public EParser(TokenStream lexer) {
  this(lexer,2);
}

public EParser(ParserSharedInputState state) {
  super(state,2);
  tokenNames = _tokenNames;
  buildTokenTypeASTClassMap();
  astFactory = new ASTFactory(getTokenTypeToASTClassMap());
}

	public final void start() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST start_AST = null;
		
		try {      // for error handling
			br();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case QUASIOPEN:
			case HEX:
			case OCTAL:
			case LITERAL_bind:
			case LITERAL_break:
			case LITERAL_continue:
			case LITERAL_def:
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_return:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_var:
			case LITERAL_when:
			case LITERAL_while:
			case LPAREN:
			case LBRACK:
			case LCURLY:
			case ATCURLY:
			case AT:
			case LNOT:
			case BNOT:
			case PLUS:
			case MINUS:
			case STAR:
			case BAND:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case IDENT:
			case INT:
			case FLOAT64:
			case XOR:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				seq();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			start_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_0);
			} else {
			  throw ex;
			}
		}
		returnAST = start_AST;
	}
	
	public final void br() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST br_AST = null;
		
		try {      // for error handling
			{
			_loop5:
			do {
				if ((LA(1)==EOL)) {
					match(EOL);
				}
				else {
					break _loop5;
				}
				
			} while (true);
			}
			br_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_1);
			} else {
			  throw ex;
			}
		}
		returnAST = br_AST;
	}
	
	public final void seq() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST seq_AST = null;
		
		try {      // for error handling
			eExpr();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case SEMI:
			case EOL:
			{
				{
				int _cnt11=0;
				_loop11:
				do {
					if ((LA(1)==SEMI||LA(1)==EOL)) {
						{
						switch ( LA(1)) {
						case SEMI:
						{
							match(SEMI);
							break;
						}
						case EOL:
						{
							match(EOL);
							break;
						}
						default:
						{
							throw new NoViableAltException(LT(1), getFilename());
						}
						}
						}
						{
						switch ( LA(1)) {
						case QUASIOPEN:
						case HEX:
						case OCTAL:
						case LITERAL_bind:
						case LITERAL_break:
						case LITERAL_continue:
						case LITERAL_def:
						case LITERAL_escape:
						case LITERAL_for:
						case LITERAL_if:
						case LITERAL_return:
						case LITERAL_switch:
						case LITERAL_try:
						case LITERAL_var:
						case LITERAL_when:
						case LITERAL_while:
						case LPAREN:
						case LBRACK:
						case LCURLY:
						case ATCURLY:
						case AT:
						case LNOT:
						case BNOT:
						case PLUS:
						case MINUS:
						case STAR:
						case BAND:
						case CHAR_LITERAL:
						case STRING_LITERAL:
						case IDENT:
						case INT:
						case FLOAT64:
						case XOR:
						case 249:
						case 251:
						case 252:
						case 253:
						case 255:
						case 256:
						{
							eExpr();
							astFactory.addASTChild(currentAST, returnAST);
							break;
						}
						case EOF:
						case RCURLY:
						case RPAREN:
						case SEMI:
						case EOL:
						{
							break;
						}
						default:
						{
							throw new NoViableAltException(LT(1), getFilename());
						}
						}
						}
					}
					else {
						if ( _cnt11>=1 ) { break _loop11; } else {throw new NoViableAltException(LT(1), getFilename());}
					}
					
					_cnt11++;
				} while (true);
				}
				if ( inputState.guessing==0 ) {
					seq_AST = (AST)currentAST.root;
					seq_AST = (AST)astFactory.make( (new ASTArray(2)).add(astFactory.create(SeqExpr)).add(seq_AST));
					currentAST.root = seq_AST;
					currentAST.child = seq_AST!=null &&seq_AST.getFirstChild()!=null ?
						seq_AST.getFirstChild() : seq_AST;
					currentAST.advanceChildToEnd();
				}
				break;
			}
			case EOF:
			case RCURLY:
			case RPAREN:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			seq_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_2);
			} else {
			  throw ex;
			}
		}
		returnAST = seq_AST;
	}
	
	public final void eExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST eExpr_AST = null;
		
		try {      // for error handling
			{
			switch ( LA(1)) {
			case QUASIOPEN:
			case HEX:
			case OCTAL:
			case LITERAL_bind:
			case LITERAL_def:
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_var:
			case LITERAL_when:
			case LITERAL_while:
			case LPAREN:
			case LBRACK:
			case LCURLY:
			case ATCURLY:
			case AT:
			case LNOT:
			case BNOT:
			case PLUS:
			case MINUS:
			case STAR:
			case BAND:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case IDENT:
			case INT:
			case FLOAT64:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				assign();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case LITERAL_break:
			case LITERAL_continue:
			case LITERAL_return:
			case XOR:
			{
				ejector();
				astFactory.addASTChild(currentAST, returnAST);
				assign();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			eExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_3);
			} else {
			  throw ex;
			}
		}
		returnAST = eExpr_AST;
	}
	
	public final void assign() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST assign_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case QUASIOPEN:
			case HEX:
			case OCTAL:
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_when:
			case LITERAL_while:
			case LPAREN:
			case LBRACK:
			case LCURLY:
			case ATCURLY:
			case AT:
			case LNOT:
			case BNOT:
			case PLUS:
			case MINUS:
			case STAR:
			case BAND:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case IDENT:
			case INT:
			case FLOAT64:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				cond();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case ASSIGN:
				{
					AST tmp4_AST = null;
					tmp4_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp4_AST);
					match(ASSIGN);
					assign();
					astFactory.addASTChild(currentAST, returnAST);
					if ( inputState.guessing==0 ) {
						assign_AST = (AST)currentAST.root;
						assign_AST.setType(AssignExpr);
					}
					break;
				}
				case FLOORDIV_ASSIGN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case REM_ASSIGN:
				case MOD_ASSIGN:
				case POW_ASSIGN:
				case SR_ASSIGN:
				case SL_ASSIGN:
				case BXOR_ASSIGN:
				case BOR_ASSIGN:
				case BAND_ASSIGN:
				{
					assignOp();
					astFactory.addASTChild(currentAST, returnAST);
					assign();
					astFactory.addASTChild(currentAST, returnAST);
					if ( inputState.guessing==0 ) {
						assign_AST = (AST)currentAST.root;
						assign_AST = (AST)astFactory.make( (new ASTArray(2)).add(astFactory.create(AssignExpr)).add(assign_AST));
						currentAST.root = assign_AST;
						currentAST.child = assign_AST!=null &&assign_AST.getFirstChild()!=null ?
							assign_AST.getFirstChild() : assign_AST;
						currentAST.advanceChildToEnd();
					}
					break;
				}
				case EOF:
				case RCURLY:
				case RPAREN:
				case RBRACK:
				case LCURLY:
				case COMMA:
				case SEMI:
				case EOL:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				assign_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_def:
			{
				AST tmp5_AST = null;
				tmp5_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp5_AST);
				match(LITERAL_def);
				{
				boolean synPredMatched37 = false;
				if (((_tokenSet_4.member(LA(1))) && (_tokenSet_5.member(LA(2))))) {
					int _m37 = mark();
					synPredMatched37 = true;
					inputState.guessing++;
					try {
						{
						pattern();
						match(ASSIGN);
						}
					}
					catch (RecognitionException pe) {
						synPredMatched37 = false;
					}
					rewind(_m37);
					inputState.guessing--;
				}
				if ( synPredMatched37 ) {
					pattern();
					astFactory.addASTChild(currentAST, returnAST);
					match(ASSIGN);
					assign();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else if ((_tokenSet_6.member(LA(1))) && (_tokenSet_7.member(LA(2)))) {
					noun();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					throw new NoViableAltException(LT(1), getFilename());
				}
				
				}
				if ( inputState.guessing==0 ) {
					assign_AST = (AST)currentAST.root;
					assign_AST.setType(DefineExpr);
				}
				assign_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_bind:
			{
				binder();
				astFactory.addASTChild(currentAST, returnAST);
				AST tmp7_AST = null;
				tmp7_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp7_AST);
				match(ASSIGN);
				assign();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					assign_AST = (AST)currentAST.root;
					assign_AST.setType(DefineExpr);
				}
				assign_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_var:
			{
				varNamer();
				astFactory.addASTChild(currentAST, returnAST);
				AST tmp8_AST = null;
				tmp8_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp8_AST);
				match(ASSIGN);
				assign();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					assign_AST = (AST)currentAST.root;
					assign_AST.setType(DefineExpr);
				}
				assign_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_8);
			} else {
			  throw ex;
			}
		}
		returnAST = assign_AST;
	}
	
	public final void ejector() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST ejector_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case LITERAL_break:
			{
				AST tmp9_AST = null;
				tmp9_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp9_AST);
				match(LITERAL_break);
				if ( inputState.guessing==0 ) {
					ejector_AST = (AST)currentAST.root;
					ejector_AST.setType(BreakExpr);
				}
				ejector_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_continue:
			{
				AST tmp10_AST = null;
				tmp10_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp10_AST);
				match(LITERAL_continue);
				if ( inputState.guessing==0 ) {
					ejector_AST = (AST)currentAST.root;
					ejector_AST.setType(ContinueExpr);
				}
				ejector_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_return:
			{
				AST tmp11_AST = null;
				tmp11_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp11_AST);
				match(LITERAL_return);
				if ( inputState.guessing==0 ) {
					ejector_AST = (AST)currentAST.root;
					ejector_AST.setType(ReturnExpr);
				}
				ejector_AST = (AST)currentAST.root;
				break;
			}
			case XOR:
			{
				AST tmp12_AST = null;
				tmp12_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp12_AST);
				match(XOR);
				if ( inputState.guessing==0 ) {
					ejector_AST = (AST)currentAST.root;
					ejector_AST.setType(ReturnExpr);
				}
				ejector_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_9);
			} else {
			  throw ex;
			}
		}
		returnAST = ejector_AST;
	}
	
	public final void basic() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST basic_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case LITERAL_if:
			{
				ifExpr();
				astFactory.addASTChild(currentAST, returnAST);
				basic_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_for:
			case LITERAL_when:
			{
				forExpr();
				astFactory.addASTChild(currentAST, returnAST);
				basic_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_while:
			{
				whileExpr();
				astFactory.addASTChild(currentAST, returnAST);
				basic_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_switch:
			{
				switchExpr();
				astFactory.addASTChild(currentAST, returnAST);
				basic_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_try:
			{
				tryExpr();
				astFactory.addASTChild(currentAST, returnAST);
				basic_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_escape:
			{
				escapeExpr();
				astFactory.addASTChild(currentAST, returnAST);
				basic_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = basic_AST;
	}
	
	public final void ifExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST ifExpr_AST = null;
		
		try {      // for error handling
			AST tmp13_AST = null;
			tmp13_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp13_AST);
			match(LITERAL_if);
			parenExpr();
			astFactory.addASTChild(currentAST, returnAST);
			body();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case LITERAL_else:
			{
				match(LITERAL_else);
				{
				switch ( LA(1)) {
				case LITERAL_if:
				{
					ifExpr();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case LCURLY:
				{
					body();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case LPAREN:
			case RPAREN:
			case LBRACK:
			case RBRACK:
			case LCURLY:
			case COLON:
			case COMMA:
			case DOT:
			case THRU:
			case TILL:
			case SAME:
			case NOTSAME:
			case DIV:
			case FLOORDIV:
			case PLUS:
			case MINUS:
			case STAR:
			case REM:
			case MOD:
			case SR:
			case GE:
			case GT:
			case SL:
			case LE:
			case ABA:
			case LT:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case POW:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case SEND:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			if ( inputState.guessing==0 ) {
				ifExpr_AST = (AST)currentAST.root;
				ifExpr_AST.setType(IfExpr);
			}
			ifExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = ifExpr_AST;
	}
	
	public final void forExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST forExpr_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case LITERAL_for:
			{
				AST tmp15_AST = null;
				tmp15_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp15_AST);
				match(LITERAL_for);
				iterPattern();
				astFactory.addASTChild(currentAST, returnAST);
				AST tmp16_AST = null;
				tmp16_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp16_AST);
				match(LITERAL_in);
				assign();
				astFactory.addASTChild(currentAST, returnAST);
				body();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case LITERAL_catch:
				{
					catcher();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case EOF:
				case RCURLY:
				case LITERAL_in:
				case QUESTION:
				case LPAREN:
				case RPAREN:
				case LBRACK:
				case RBRACK:
				case LCURLY:
				case COLON:
				case COMMA:
				case DOT:
				case THRU:
				case TILL:
				case SAME:
				case NOTSAME:
				case DIV:
				case FLOORDIV:
				case PLUS:
				case MINUS:
				case STAR:
				case REM:
				case MOD:
				case SR:
				case GE:
				case GT:
				case SL:
				case LE:
				case ABA:
				case LT:
				case BXOR:
				case BOR:
				case LOR:
				case BAND:
				case BUTNOT:
				case LAND:
				case SEMI:
				case POW:
				case ASSIGN:
				case FLOORDIV_ASSIGN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case REM_ASSIGN:
				case MOD_ASSIGN:
				case POW_ASSIGN:
				case SR_ASSIGN:
				case SL_ASSIGN:
				case BXOR_ASSIGN:
				case BOR_ASSIGN:
				case BAND_ASSIGN:
				case SEND:
				case MATCHBIND:
				case MISMATCH:
				case EOL:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				if ( inputState.guessing==0 ) {
					forExpr_AST = (AST)currentAST.root;
					forExpr_AST.setType(ForExpr);
				}
				forExpr_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_when:
			{
				AST tmp17_AST = null;
				tmp17_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp17_AST);
				match(LITERAL_when);
				iterPattern();
				astFactory.addASTChild(currentAST, returnAST);
				AST tmp18_AST = null;
				tmp18_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp18_AST);
				match(LITERAL_in);
				assign();
				astFactory.addASTChild(currentAST, returnAST);
				body();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					forExpr_AST = (AST)currentAST.root;
					forExpr_AST.setType(ForExpr);
				}
				forExpr_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = forExpr_AST;
	}
	
	public final void whileExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST whileExpr_AST = null;
		
		try {      // for error handling
			AST tmp19_AST = null;
			tmp19_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp19_AST);
			match(LITERAL_while);
			parenExpr();
			astFactory.addASTChild(currentAST, returnAST);
			body();
			astFactory.addASTChild(currentAST, returnAST);
			if ( inputState.guessing==0 ) {
				whileExpr_AST = (AST)currentAST.root;
				whileExpr_AST.setType(WhileExpr);
			}
			{
			switch ( LA(1)) {
			case LITERAL_catch:
			{
				catcher();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case LPAREN:
			case RPAREN:
			case LBRACK:
			case RBRACK:
			case LCURLY:
			case COLON:
			case COMMA:
			case DOT:
			case THRU:
			case TILL:
			case SAME:
			case NOTSAME:
			case DIV:
			case FLOORDIV:
			case PLUS:
			case MINUS:
			case STAR:
			case REM:
			case MOD:
			case SR:
			case GE:
			case GT:
			case SL:
			case LE:
			case ABA:
			case LT:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case POW:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case SEND:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			whileExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = whileExpr_AST;
	}
	
	public final void switchExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST switchExpr_AST = null;
		
		try {      // for error handling
			AST tmp20_AST = null;
			tmp20_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp20_AST);
			match(LITERAL_switch);
			parenExpr();
			astFactory.addASTChild(currentAST, returnAST);
			match(LBRACK);
			br();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop26:
			do {
				if ((LA(1)==LITERAL_match)) {
					match(LITERAL_match);
					pattern();
					astFactory.addASTChild(currentAST, returnAST);
					body();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop26;
				}
				
			} while (true);
			}
			match(RBRACK);
			if ( inputState.guessing==0 ) {
				switchExpr_AST = (AST)currentAST.root;
				switchExpr_AST.setType(SwitchExpr);
			}
			switchExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = switchExpr_AST;
	}
	
	public final void tryExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST tryExpr_AST = null;
		
		try {      // for error handling
			AST tmp24_AST = null;
			tmp24_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp24_AST);
			match(LITERAL_try);
			body();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop29:
			do {
				if ((LA(1)==LITERAL_catch)) {
					match(LITERAL_catch);
					pattern();
					astFactory.addASTChild(currentAST, returnAST);
					body();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop29;
				}
				
			} while (true);
			}
			if ( inputState.guessing==0 ) {
				tryExpr_AST = (AST)currentAST.root;
				tryExpr_AST.setType(TryExpr);
			}
			{
			switch ( LA(1)) {
			case LITERAL_finally:
			{
				AST tmp26_AST = null;
				tmp26_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp26_AST);
				match(LITERAL_finally);
				body();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					tryExpr_AST = (AST)currentAST.root;
					tryExpr_AST.setType(FinallyExpr);
				}
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case LPAREN:
			case RPAREN:
			case LBRACK:
			case RBRACK:
			case LCURLY:
			case COLON:
			case COMMA:
			case DOT:
			case THRU:
			case TILL:
			case SAME:
			case NOTSAME:
			case DIV:
			case FLOORDIV:
			case PLUS:
			case MINUS:
			case STAR:
			case REM:
			case MOD:
			case SR:
			case GE:
			case GT:
			case SL:
			case LE:
			case ABA:
			case LT:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case POW:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case SEND:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			tryExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = tryExpr_AST;
	}
	
	public final void escapeExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST escapeExpr_AST = null;
		
		try {      // for error handling
			AST tmp27_AST = null;
			tmp27_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp27_AST);
			match(LITERAL_escape);
			pattern();
			astFactory.addASTChild(currentAST, returnAST);
			body();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case LITERAL_catch:
			{
				catcher();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case LPAREN:
			case RPAREN:
			case LBRACK:
			case RBRACK:
			case LCURLY:
			case COLON:
			case COMMA:
			case DOT:
			case THRU:
			case TILL:
			case SAME:
			case NOTSAME:
			case DIV:
			case FLOORDIV:
			case PLUS:
			case MINUS:
			case STAR:
			case REM:
			case MOD:
			case SR:
			case GE:
			case GT:
			case SL:
			case LE:
			case ABA:
			case LT:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case POW:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case SEND:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			if ( inputState.guessing==0 ) {
				escapeExpr_AST = (AST)currentAST.root;
				escapeExpr_AST.setType(EscapeExpr);
			}
			escapeExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = escapeExpr_AST;
	}
	
	public final void parenExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST parenExpr_AST = null;
		
		try {      // for error handling
			match(LPAREN);
			br();
			astFactory.addASTChild(currentAST, returnAST);
			seq();
			astFactory.addASTChild(currentAST, returnAST);
			match(RPAREN);
			parenExpr_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_11);
			} else {
			  throw ex;
			}
		}
		returnAST = parenExpr_AST;
	}
	
	public final void body() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST body_AST = null;
		
		try {      // for error handling
			match(LCURLY);
			br();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case RCURLY:
			{
				match(RCURLY);
				break;
			}
			case QUASIOPEN:
			case HEX:
			case OCTAL:
			case LITERAL_bind:
			case LITERAL_break:
			case LITERAL_continue:
			case LITERAL_def:
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_return:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_var:
			case LITERAL_when:
			case LITERAL_while:
			case LPAREN:
			case LBRACK:
			case LCURLY:
			case ATCURLY:
			case AT:
			case LNOT:
			case BNOT:
			case PLUS:
			case MINUS:
			case STAR:
			case BAND:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case IDENT:
			case INT:
			case FLOAT64:
			case XOR:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				seq();
				astFactory.addASTChild(currentAST, returnAST);
				match(RCURLY);
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			body_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_12);
			} else {
			  throw ex;
			}
		}
		returnAST = body_AST;
	}
	
	public final void iterPattern() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST iterPattern_AST = null;
		
		try {      // for error handling
			pattern();
			astFactory.addASTChild(currentAST, returnAST);
			iterPattern_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_13);
			} else {
			  throw ex;
			}
		}
		returnAST = iterPattern_AST;
	}
	
	public final void catcher() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST catcher_AST = null;
		
		try {      // for error handling
			match(LITERAL_catch);
			pattern();
			astFactory.addASTChild(currentAST, returnAST);
			body();
			astFactory.addASTChild(currentAST, returnAST);
			catcher_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = catcher_AST;
	}
	
	public final void pattern() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST pattern_AST = null;
		
		try {      // for error handling
			listPatt();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case QUESTION:
			{
				AST tmp34_AST = null;
				tmp34_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp34_AST);
				match(QUESTION);
				order();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COMMA:
			case LOR:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			pattern_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_14);
			} else {
			  throw ex;
			}
		}
		returnAST = pattern_AST;
	}
	
	public final void cond() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST cond_AST = null;
		
		try {      // for error handling
			condAnd();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop42:
			do {
				if ((LA(1)==LOR)) {
					AST tmp35_AST = null;
					tmp35_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp35_AST);
					match(LOR);
					condAnd();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop42;
				}
				
			} while (true);
			}
			cond_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_15);
			} else {
			  throw ex;
			}
		}
		returnAST = cond_AST;
	}
	
	public final void assignOp() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST assignOp_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case FLOORDIV_ASSIGN:
			{
				AST tmp36_AST = null;
				tmp36_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp36_AST);
				match(FLOORDIV_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case PLUS_ASSIGN:
			{
				AST tmp37_AST = null;
				tmp37_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp37_AST);
				match(PLUS_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case MINUS_ASSIGN:
			{
				AST tmp38_AST = null;
				tmp38_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp38_AST);
				match(MINUS_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case STAR_ASSIGN:
			{
				AST tmp39_AST = null;
				tmp39_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp39_AST);
				match(STAR_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case DIV_ASSIGN:
			{
				AST tmp40_AST = null;
				tmp40_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp40_AST);
				match(DIV_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case REM_ASSIGN:
			{
				AST tmp41_AST = null;
				tmp41_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp41_AST);
				match(REM_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case MOD_ASSIGN:
			{
				AST tmp42_AST = null;
				tmp42_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp42_AST);
				match(MOD_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case POW_ASSIGN:
			{
				AST tmp43_AST = null;
				tmp43_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp43_AST);
				match(POW_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case SR_ASSIGN:
			{
				AST tmp44_AST = null;
				tmp44_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp44_AST);
				match(SR_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case SL_ASSIGN:
			{
				AST tmp45_AST = null;
				tmp45_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp45_AST);
				match(SL_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case BAND_ASSIGN:
			{
				AST tmp46_AST = null;
				tmp46_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp46_AST);
				match(BAND_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case BXOR_ASSIGN:
			{
				AST tmp47_AST = null;
				tmp47_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp47_AST);
				match(BXOR_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			case BOR_ASSIGN:
			{
				AST tmp48_AST = null;
				tmp48_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp48_AST);
				match(BOR_ASSIGN);
				assignOp_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_9);
			} else {
			  throw ex;
			}
		}
		returnAST = assignOp_AST;
	}
	
	public final void noun() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST noun_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case IDENT:
			{
				AST tmp49_AST = null;
				tmp49_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp49_AST);
				match(IDENT);
				noun_AST = (AST)currentAST.root;
				break;
			}
			case 249:
			{
				AST tmp50_AST = null;
				tmp50_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp50_AST);
				match(249);
				AST tmp51_AST = null;
				tmp51_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp51_AST);
				match(LiteralString);
				noun_AST = (AST)currentAST.root;
				break;
			}
			case 251:
			{
				AST tmp52_AST = null;
				tmp52_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp52_AST);
				match(251);
				AST tmp53_AST = null;
				tmp53_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp53_AST);
				match(LiteralString);
				noun_AST = (AST)currentAST.root;
				break;
			}
			case 252:
			{
				AST tmp54_AST = null;
				tmp54_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp54_AST);
				match(252);
				AST tmp55_AST = null;
				tmp55_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp55_AST);
				match(LiteralString);
				noun_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_16);
			} else {
			  throw ex;
			}
		}
		returnAST = noun_AST;
	}
	
	public final void binder() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST binder_AST = null;
		
		try {      // for error handling
			AST tmp56_AST = null;
			tmp56_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp56_AST);
			match(LITERAL_bind);
			noun();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case COLON:
			{
				match(COLON);
				guard();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COMMA:
			case LOR:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			if ( inputState.guessing==0 ) {
				binder_AST = (AST)currentAST.root;
				binder_AST.setType(BindPattern);
			}
			binder_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_17);
			} else {
			  throw ex;
			}
		}
		returnAST = binder_AST;
	}
	
	public final void varNamer() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST varNamer_AST = null;
		
		try {      // for error handling
			AST tmp58_AST = null;
			tmp58_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp58_AST);
			match(LITERAL_var);
			nounExpr();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case COLON:
			{
				match(COLON);
				guard();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COMMA:
			case LOR:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			if ( inputState.guessing==0 ) {
				varNamer_AST = (AST)currentAST.root;
				varNamer_AST.setType(VarPattern);
			}
			varNamer_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_17);
			} else {
			  throw ex;
			}
		}
		returnAST = varNamer_AST;
	}
	
	public final void condAnd() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST condAnd_AST = null;
		
		try {      // for error handling
			logical();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop45:
			do {
				if ((LA(1)==LAND)) {
					AST tmp60_AST = null;
					tmp60_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp60_AST);
					match(LAND);
					logical();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop45;
				}
				
			} while (true);
			}
			condAnd_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_18);
			} else {
			  throw ex;
			}
		}
		returnAST = condAnd_AST;
	}
	
	public final void logical() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST logical_AST = null;
		
		try {      // for error handling
			order();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case SAME:
			{
				AST tmp61_AST = null;
				tmp61_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp61_AST);
				match(SAME);
				order();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case NOTSAME:
			{
				AST tmp62_AST = null;
				tmp62_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp62_AST);
				match(NOTSAME);
				order();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case BAND:
			{
				{
				int _cnt49=0;
				_loop49:
				do {
					if ((LA(1)==BAND)) {
						AST tmp63_AST = null;
						tmp63_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp63_AST);
						match(BAND);
						order();
						astFactory.addASTChild(currentAST, returnAST);
					}
					else {
						if ( _cnt49>=1 ) { break _loop49; } else {throw new NoViableAltException(LT(1), getFilename());}
					}
					
					_cnt49++;
				} while (true);
				}
				break;
			}
			case BOR:
			{
				{
				int _cnt51=0;
				_loop51:
				do {
					if ((LA(1)==BOR)) {
						AST tmp64_AST = null;
						tmp64_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp64_AST);
						match(BOR);
						order();
						astFactory.addASTChild(currentAST, returnAST);
					}
					else {
						if ( _cnt51>=1 ) { break _loop51; } else {throw new NoViableAltException(LT(1), getFilename());}
					}
					
					_cnt51++;
				} while (true);
				}
				break;
			}
			case BXOR:
			{
				{
				int _cnt53=0;
				_loop53:
				do {
					if ((LA(1)==BXOR)) {
						AST tmp65_AST = null;
						tmp65_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp65_AST);
						match(BXOR);
						order();
						astFactory.addASTChild(currentAST, returnAST);
					}
					else {
						if ( _cnt53>=1 ) { break _loop53; } else {throw new NoViableAltException(LT(1), getFilename());}
					}
					
					_cnt53++;
				} while (true);
				}
				break;
			}
			case BUTNOT:
			{
				AST tmp66_AST = null;
				tmp66_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp66_AST);
				match(BUTNOT);
				order();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case MATCHBIND:
			{
				AST tmp67_AST = null;
				tmp67_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp67_AST);
				match(MATCHBIND);
				pattern();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case MISMATCH:
			{
				AST tmp68_AST = null;
				tmp68_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp68_AST);
				match(MISMATCH);
				pattern();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COMMA:
			case LOR:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			logical_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_19);
			} else {
			  throw ex;
			}
		}
		returnAST = logical_AST;
	}
	
	public final void order() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST order_AST = null;
		
		try {      // for error handling
			interval();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case GE:
			case GT:
			case LE:
			case ABA:
			case LT:
			{
				compOp();
				astFactory.addASTChild(currentAST, returnAST);
				interval();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					order_AST = (AST)currentAST.root;
					order_AST = (AST)astFactory.make( (new ASTArray(2)).add(astFactory.create(CallExpr)).add(order_AST));
					currentAST.root = order_AST;
					currentAST.child = order_AST!=null &&order_AST.getFirstChild()!=null ?
						order_AST.getFirstChild() : order_AST;
					currentAST.advanceChildToEnd();
				}
				break;
			}
			case COLON:
			{
				AST tmp69_AST = null;
				tmp69_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp69_AST);
				match(COLON);
				guard();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COMMA:
			case SAME:
			case NOTSAME:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			order_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_20);
			} else {
			  throw ex;
			}
		}
		returnAST = order_AST;
	}
	
	public final void interval() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST interval_AST = null;
		
		try {      // for error handling
			shift();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case THRU:
			case TILL:
			{
				{
				switch ( LA(1)) {
				case THRU:
				{
					AST tmp70_AST = null;
					tmp70_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp70_AST);
					match(THRU);
					break;
				}
				case TILL:
				{
					AST tmp71_AST = null;
					tmp71_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp71_AST);
					match(TILL);
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				shift();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COLON:
			case COMMA:
			case SAME:
			case NOTSAME:
			case GE:
			case GT:
			case LE:
			case ABA:
			case LT:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			interval_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_21);
			} else {
			  throw ex;
			}
		}
		returnAST = interval_AST;
	}
	
	public final void compOp() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST compOp_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case LT:
			{
				AST tmp72_AST = null;
				tmp72_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp72_AST);
				match(LT);
				compOp_AST = (AST)currentAST.root;
				break;
			}
			case LE:
			{
				AST tmp73_AST = null;
				tmp73_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp73_AST);
				match(LE);
				compOp_AST = (AST)currentAST.root;
				break;
			}
			case ABA:
			{
				AST tmp74_AST = null;
				tmp74_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp74_AST);
				match(ABA);
				compOp_AST = (AST)currentAST.root;
				break;
			}
			case GE:
			{
				AST tmp75_AST = null;
				tmp75_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp75_AST);
				match(GE);
				compOp_AST = (AST)currentAST.root;
				break;
			}
			case GT:
			{
				AST tmp76_AST = null;
				tmp76_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp76_AST);
				match(GT);
				compOp_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_22);
			} else {
			  throw ex;
			}
		}
		returnAST = compOp_AST;
	}
	
	public final void guard() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST guard_AST = null;
		
		try {      // for error handling
			AST tmp77_AST = null;
			tmp77_AST = astFactory.create(LT(1));
			astFactory.addASTChild(currentAST, tmp77_AST);
			match(IDENT);
			guard_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_23);
			} else {
			  throw ex;
			}
		}
		returnAST = guard_AST;
	}
	
	public final void shift() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST shift_AST = null;
		
		try {      // for error handling
			add();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop63:
			do {
				if ((LA(1)==SR||LA(1)==SL)) {
					{
					switch ( LA(1)) {
					case SL:
					{
						AST tmp78_AST = null;
						tmp78_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp78_AST);
						match(SL);
						break;
					}
					case SR:
					{
						AST tmp79_AST = null;
						tmp79_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp79_AST);
						match(SR);
						break;
					}
					default:
					{
						throw new NoViableAltException(LT(1), getFilename());
					}
					}
					}
					add();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop63;
				}
				
			} while (true);
			}
			shift_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_24);
			} else {
			  throw ex;
			}
		}
		returnAST = shift_AST;
	}
	
	public final void add() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST add_AST = null;
		
		try {      // for error handling
			mult();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop67:
			do {
				if ((LA(1)==PLUS||LA(1)==MINUS)) {
					{
					switch ( LA(1)) {
					case PLUS:
					{
						AST tmp80_AST = null;
						tmp80_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp80_AST);
						match(PLUS);
						break;
					}
					case MINUS:
					{
						AST tmp81_AST = null;
						tmp81_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp81_AST);
						match(MINUS);
						break;
					}
					default:
					{
						throw new NoViableAltException(LT(1), getFilename());
					}
					}
					}
					mult();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop67;
				}
				
			} while (true);
			}
			add_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_25);
			} else {
			  throw ex;
			}
		}
		returnAST = add_AST;
	}
	
	public final void mult() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST mult_AST = null;
		
		try {      // for error handling
			pow();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop71:
			do {
				if ((_tokenSet_26.member(LA(1)))) {
					{
					switch ( LA(1)) {
					case STAR:
					{
						AST tmp82_AST = null;
						tmp82_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp82_AST);
						match(STAR);
						break;
					}
					case DIV:
					{
						AST tmp83_AST = null;
						tmp83_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp83_AST);
						match(DIV);
						break;
					}
					case FLOORDIV:
					{
						AST tmp84_AST = null;
						tmp84_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp84_AST);
						match(FLOORDIV);
						break;
					}
					case REM:
					{
						AST tmp85_AST = null;
						tmp85_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp85_AST);
						match(REM);
						break;
					}
					case MOD:
					{
						AST tmp86_AST = null;
						tmp86_AST = astFactory.create(LT(1));
						astFactory.makeASTRoot(currentAST, tmp86_AST);
						match(MOD);
						break;
					}
					default:
					{
						throw new NoViableAltException(LT(1), getFilename());
					}
					}
					}
					pow();
					astFactory.addASTChild(currentAST, returnAST);
				}
				else {
					break _loop71;
				}
				
			} while (true);
			}
			mult_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_27);
			} else {
			  throw ex;
			}
		}
		returnAST = mult_AST;
	}
	
	public final void pow() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST pow_AST = null;
		
		try {      // for error handling
			prefix();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case POW:
			{
				AST tmp87_AST = null;
				tmp87_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp87_AST);
				match(POW);
				prefix();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COLON:
			case COMMA:
			case THRU:
			case TILL:
			case SAME:
			case NOTSAME:
			case DIV:
			case FLOORDIV:
			case PLUS:
			case MINUS:
			case STAR:
			case REM:
			case MOD:
			case SR:
			case GE:
			case GT:
			case SL:
			case LE:
			case ABA:
			case LT:
			case BXOR:
			case BOR:
			case LOR:
			case BAND:
			case BUTNOT:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case MATCHBIND:
			case MISMATCH:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			pow_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_28);
			} else {
			  throw ex;
			}
		}
		returnAST = pow_AST;
	}
	
	public final void prefix() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST prefix_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case QUASIOPEN:
			case HEX:
			case OCTAL:
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_when:
			case LITERAL_while:
			case LPAREN:
			case LBRACK:
			case LCURLY:
			case ATCURLY:
			case AT:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case IDENT:
			case INT:
			case FLOAT64:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				postfix();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			case LNOT:
			{
				AST tmp88_AST = null;
				tmp88_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp88_AST);
				match(LNOT);
				postfix();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			case BNOT:
			{
				AST tmp89_AST = null;
				tmp89_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp89_AST);
				match(BNOT);
				postfix();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			case BAND:
			{
				AST tmp90_AST = null;
				tmp90_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp90_AST);
				match(BAND);
				postfix();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			case STAR:
			{
				AST tmp91_AST = null;
				tmp91_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp91_AST);
				match(STAR);
				postfix();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			case PLUS:
			{
				AST tmp92_AST = null;
				tmp92_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp92_AST);
				match(PLUS);
				postfix();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			case MINUS:
			{
				AST tmp93_AST = null;
				tmp93_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp93_AST);
				match(MINUS);
				prim();
				astFactory.addASTChild(currentAST, returnAST);
				prefix_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_29);
			} else {
			  throw ex;
			}
		}
		returnAST = prefix_AST;
	}
	
	public final void postfix() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST postfix_AST = null;
		
		try {      // for error handling
			call();
			astFactory.addASTChild(currentAST, returnAST);
			postfix_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_29);
			} else {
			  throw ex;
			}
		}
		returnAST = postfix_AST;
	}
	
	public final void prim() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST prim_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case HEX:
			case OCTAL:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case INT:
			case FLOAT64:
			{
				literal();
				astFactory.addASTChild(currentAST, returnAST);
				prim_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_when:
			case LITERAL_while:
			{
				basic();
				astFactory.addASTChild(currentAST, returnAST);
				prim_AST = (AST)currentAST.root;
				break;
			}
			case ATCURLY:
			case AT:
			case IDENT:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				nounExpr();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case QUASIOPEN:
				{
					quasiString();
					astFactory.addASTChild(currentAST, returnAST);
					if ( inputState.guessing==0 ) {
						prim_AST = (AST)currentAST.root;
						prim_AST = (AST)astFactory.make( (new ASTArray(2)).add(astFactory.create(QuasiLiteralExpr)).add(prim_AST));
						currentAST.root = prim_AST;
						currentAST.child = prim_AST!=null &&prim_AST.getFirstChild()!=null ?
							prim_AST.getFirstChild() : prim_AST;
						currentAST.advanceChildToEnd();
					}
					break;
				}
				case EOF:
				case RCURLY:
				case LITERAL_in:
				case QUESTION:
				case LPAREN:
				case RPAREN:
				case LBRACK:
				case RBRACK:
				case LCURLY:
				case COLON:
				case COMMA:
				case DOT:
				case THRU:
				case TILL:
				case SAME:
				case NOTSAME:
				case DIV:
				case FLOORDIV:
				case PLUS:
				case MINUS:
				case STAR:
				case REM:
				case MOD:
				case SR:
				case GE:
				case GT:
				case SL:
				case LE:
				case ABA:
				case LT:
				case BXOR:
				case BOR:
				case LOR:
				case BAND:
				case BUTNOT:
				case LAND:
				case SEMI:
				case POW:
				case ASSIGN:
				case FLOORDIV_ASSIGN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case REM_ASSIGN:
				case MOD_ASSIGN:
				case POW_ASSIGN:
				case SR_ASSIGN:
				case SL_ASSIGN:
				case BXOR_ASSIGN:
				case BOR_ASSIGN:
				case BAND_ASSIGN:
				case SEND:
				case MATCHBIND:
				case MISMATCH:
				case EOL:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				prim_AST = (AST)currentAST.root;
				break;
			}
			case LPAREN:
			{
				parenExpr();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case QUASIOPEN:
				{
					quasiString();
					astFactory.addASTChild(currentAST, returnAST);
					if ( inputState.guessing==0 ) {
						prim_AST = (AST)currentAST.root;
						prim_AST = (AST)astFactory.make( (new ASTArray(2)).add(astFactory.create(QuasiLiteralExpr)).add(prim_AST));
						currentAST.root = prim_AST;
						currentAST.child = prim_AST!=null &&prim_AST.getFirstChild()!=null ?
							prim_AST.getFirstChild() : prim_AST;
						currentAST.advanceChildToEnd();
					}
					break;
				}
				case EOF:
				case RCURLY:
				case LITERAL_in:
				case QUESTION:
				case LPAREN:
				case RPAREN:
				case LBRACK:
				case RBRACK:
				case LCURLY:
				case COLON:
				case COMMA:
				case DOT:
				case THRU:
				case TILL:
				case SAME:
				case NOTSAME:
				case DIV:
				case FLOORDIV:
				case PLUS:
				case MINUS:
				case STAR:
				case REM:
				case MOD:
				case SR:
				case GE:
				case GT:
				case SL:
				case LE:
				case ABA:
				case LT:
				case BXOR:
				case BOR:
				case LOR:
				case BAND:
				case BUTNOT:
				case LAND:
				case SEMI:
				case POW:
				case ASSIGN:
				case FLOORDIV_ASSIGN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case REM_ASSIGN:
				case MOD_ASSIGN:
				case POW_ASSIGN:
				case SR_ASSIGN:
				case SL_ASSIGN:
				case BXOR_ASSIGN:
				case BOR_ASSIGN:
				case BAND_ASSIGN:
				case SEND:
				case MATCHBIND:
				case MISMATCH:
				case EOL:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				prim_AST = (AST)currentAST.root;
				break;
			}
			case QUASIOPEN:
			{
				quasiString();
				astFactory.addASTChild(currentAST, returnAST);
				prim_AST = (AST)currentAST.root;
				break;
			}
			case LBRACK:
			{
				AST tmp94_AST = null;
				tmp94_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp94_AST);
				match(LBRACK);
				br();
				astFactory.addASTChild(currentAST, returnAST);
				argList();
				astFactory.addASTChild(currentAST, returnAST);
				match(RBRACK);
				if ( inputState.guessing==0 ) {
					prim_AST = (AST)currentAST.root;
					prim_AST.setType(TupleExpr);
				}
				prim_AST = (AST)currentAST.root;
				break;
			}
			case LCURLY:
			{
				body();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					prim_AST = (AST)currentAST.root;
					prim_AST.setType(HideExpr);
				}
				prim_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = prim_AST;
	}
	
/**
 * Disambiguate "foo.name(args)" into being a single call rather than
 * being equivalent to "(foo.name)(args)".  If the following
 * production were folded into the above "postfix", we would indeed
 * have this ambiguity.
 * <p>
 * We use parenArgsTail rather than parenArgs in one place below so
 * that we can capture the source position of the '('.
 */
	public final void call() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST call_AST = null;
		
		try {      // for error handling
			prim();
			astFactory.addASTChild(currentAST, returnAST);
			{
			_loop79:
			do {
				switch ( LA(1)) {
				case LPAREN:
				{
					parenArgs();
					astFactory.addASTChild(currentAST, returnAST);
					if ( inputState.guessing==0 ) {
						call_AST = (AST)currentAST.root;
						call_AST = (AST)astFactory.make( (new ASTArray(3)).add(astFactory.create(CallExpr,"run")).add(astFactory.create(STRING_LITERAL,"run")).add(call_AST));
						currentAST.root = call_AST;
						currentAST.child = call_AST!=null &&call_AST.getFirstChild()!=null ?
							call_AST.getFirstChild() : call_AST;
						currentAST.advanceChildToEnd();
					}
					break;
				}
				case DOT:
				{
					AST tmp96_AST = null;
					tmp96_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp96_AST);
					match(DOT);
					verb();
					astFactory.addASTChild(currentAST, returnAST);
					parenArgs();
					astFactory.addASTChild(currentAST, returnAST);
					if ( inputState.guessing==0 ) {
						call_AST = (AST)currentAST.root;
						call_AST.setType(CallExpr);
					}
					break;
				}
				case LBRACK:
				{
					AST tmp97_AST = null;
					tmp97_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp97_AST);
					match(LBRACK);
					br();
					astFactory.addASTChild(currentAST, returnAST);
					argList();
					astFactory.addASTChild(currentAST, returnAST);
					match(RBRACK);
					if ( inputState.guessing==0 ) {
						call_AST = (AST)currentAST.root;
						call_AST.setType(GetExpr);
					}
					break;
				}
				case SEND:
				{
					AST tmp99_AST = null;
					tmp99_AST = astFactory.create(LT(1));
					astFactory.makeASTRoot(currentAST, tmp99_AST);
					match(SEND);
					{
					switch ( LA(1)) {
					case STRING_LITERAL:
					case IDENT:
					{
						verb();
						astFactory.addASTChild(currentAST, returnAST);
						parenArgs();
						astFactory.addASTChild(currentAST, returnAST);
						break;
					}
					case LPAREN:
					{
						parenArgs();
						astFactory.addASTChild(currentAST, returnAST);
						break;
					}
					default:
					{
						throw new NoViableAltException(LT(1), getFilename());
					}
					}
					}
					if ( inputState.guessing==0 ) {
						call_AST = (AST)currentAST.root;
						call_AST.setType(SendExpr);
					}
					break;
				}
				default:
				{
					break _loop79;
				}
				}
			} while (true);
			}
			call_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_29);
			} else {
			  throw ex;
			}
		}
		returnAST = call_AST;
	}
	
	public final void parenArgs() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST parenArgs_AST = null;
		
		try {      // for error handling
			match(LPAREN);
			argList();
			astFactory.addASTChild(currentAST, returnAST);
			match(RPAREN);
			parenArgs_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_30);
			} else {
			  throw ex;
			}
		}
		returnAST = parenArgs_AST;
	}
	
	public final void verb() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST verb_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case IDENT:
			{
				AST tmp102_AST = null;
				tmp102_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp102_AST);
				match(IDENT);
				verb_AST = (AST)currentAST.root;
				break;
			}
			case STRING_LITERAL:
			{
				AST tmp103_AST = null;
				tmp103_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp103_AST);
				match(STRING_LITERAL);
				verb_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_31);
			} else {
			  throw ex;
			}
		}
		returnAST = verb_AST;
	}
	
	public final void argList() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST argList_AST = null;
		
		try {      // for error handling
			{
			switch ( LA(1)) {
			case QUASIOPEN:
			case HEX:
			case OCTAL:
			case LITERAL_bind:
			case LITERAL_break:
			case LITERAL_continue:
			case LITERAL_def:
			case LITERAL_escape:
			case LITERAL_for:
			case LITERAL_if:
			case LITERAL_return:
			case LITERAL_switch:
			case LITERAL_try:
			case LITERAL_var:
			case LITERAL_when:
			case LITERAL_while:
			case LPAREN:
			case LBRACK:
			case LCURLY:
			case ATCURLY:
			case AT:
			case LNOT:
			case BNOT:
			case PLUS:
			case MINUS:
			case STAR:
			case BAND:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case IDENT:
			case INT:
			case FLOAT64:
			case XOR:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				eExpr();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case COMMA:
				{
					match(COMMA);
					argList();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case RPAREN:
				case RBRACK:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				break;
			}
			case RPAREN:
			case RBRACK:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			argList_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_32);
			} else {
			  throw ex;
			}
		}
		returnAST = argList_AST;
	}
	
	public final void literal() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST literal_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case STRING_LITERAL:
			{
				AST tmp105_AST = null;
				tmp105_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp105_AST);
				match(STRING_LITERAL);
				literal_AST = (AST)currentAST.root;
				break;
			}
			case CHAR_LITERAL:
			{
				AST tmp106_AST = null;
				tmp106_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp106_AST);
				match(CHAR_LITERAL);
				literal_AST = (AST)currentAST.root;
				break;
			}
			case INT:
			{
				AST tmp107_AST = null;
				tmp107_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp107_AST);
				match(INT);
				literal_AST = (AST)currentAST.root;
				break;
			}
			case FLOAT64:
			{
				AST tmp108_AST = null;
				tmp108_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp108_AST);
				match(FLOAT64);
				literal_AST = (AST)currentAST.root;
				break;
			}
			case HEX:
			{
				AST tmp109_AST = null;
				tmp109_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp109_AST);
				match(HEX);
				literal_AST = (AST)currentAST.root;
				break;
			}
			case OCTAL:
			{
				AST tmp110_AST = null;
				tmp110_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp110_AST);
				match(OCTAL);
				literal_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_33);
			} else {
			  throw ex;
			}
		}
		returnAST = literal_AST;
	}
	
	public final void nounExpr() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST nounExpr_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case IDENT:
			case 249:
			case 251:
			case 252:
			{
				noun();
				astFactory.addASTChild(currentAST, returnAST);
				nounExpr_AST = (AST)currentAST.root;
				break;
			}
			case 253:
			case 255:
			case 256:
			{
				dollarHole();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					nounExpr_AST = (AST)currentAST.root;
					nounExpr_AST.setType(QuasiLiteralPattern);
				}
				nounExpr_AST = (AST)currentAST.root;
				break;
			}
			case ATCURLY:
			case AT:
			{
				atHole();
				astFactory.addASTChild(currentAST, returnAST);
				if ( inputState.guessing==0 ) {
					nounExpr_AST = (AST)currentAST.root;
					nounExpr_AST.setType(QuasiPatternPattern);
				}
				nounExpr_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_16);
			} else {
			  throw ex;
			}
		}
		returnAST = nounExpr_AST;
	}
	
	public final void quasiString() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST quasiString_AST = null;
		
		try {      // for error handling
			match(QUASIOPEN);
			if ( inputState.guessing==0 ) {
				quasiString_AST = (AST)currentAST.root;
				QuasiParser p = new QuasiParser(getInputState());
				p.quasiContent();
				quasiString_AST = p.getAST();
				currentAST.root = quasiString_AST;
				currentAST.child = quasiString_AST!=null &&quasiString_AST.getFirstChild()!=null ?
					quasiString_AST.getFirstChild() : quasiString_AST;
				currentAST.advanceChildToEnd();
			}
			match(QUASICLOSE);
			quasiString_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_10);
			} else {
			  throw ex;
			}
		}
		returnAST = quasiString_AST;
	}
	
	public final void prop() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST prop_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case IDENT:
			{
				AST tmp113_AST = null;
				tmp113_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp113_AST);
				match(IDENT);
				prop_AST = (AST)currentAST.root;
				break;
			}
			case STRING_LITERAL:
			{
				AST tmp114_AST = null;
				tmp114_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp114_AST);
				match(STRING_LITERAL);
				prop_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_0);
			} else {
			  throw ex;
			}
		}
		returnAST = prop_AST;
	}
	
	public final void listPatt() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST listPatt_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case QUASIOPEN:
			case LITERAL_bind:
			case LITERAL_var:
			case LITERAL__:
			case LPAREN:
			case ATCURLY:
			case AT:
			case SAME:
			case NOTSAME:
			case GE:
			case GT:
			case LE:
			case ABA:
			case LT:
			case LAND:
			case IDENT:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				eqPatt();
				astFactory.addASTChild(currentAST, returnAST);
				listPatt_AST = (AST)currentAST.root;
				break;
			}
			case LBRACK:
			{
				AST tmp115_AST = null;
				tmp115_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp115_AST);
				match(LBRACK);
				br();
				astFactory.addASTChild(currentAST, returnAST);
				{
				boolean synPredMatched99 = false;
				if (((_tokenSet_34.member(LA(1))) && (_tokenSet_35.member(LA(2))))) {
					int _m99 = mark();
					synPredMatched99 = true;
					inputState.guessing++;
					try {
						{
						key();
						match(MAPSTO);
						}
					}
					catch (RecognitionException pe) {
						synPredMatched99 = false;
					}
					rewind(_m99);
					inputState.guessing--;
				}
				if ( synPredMatched99 ) {
					mapPattList();
					astFactory.addASTChild(currentAST, returnAST);
					match(RBRACK);
					{
					switch ( LA(1)) {
					case BOR:
					{
						AST tmp117_AST = null;
						tmp117_AST = astFactory.create(LT(1));
						astFactory.addASTChild(currentAST, tmp117_AST);
						match(BOR);
						listPatt();
						astFactory.addASTChild(currentAST, returnAST);
						break;
					}
					case EOF:
					case RCURLY:
					case LITERAL_in:
					case QUESTION:
					case RPAREN:
					case RBRACK:
					case LCURLY:
					case COMMA:
					case LOR:
					case LAND:
					case SEMI:
					case ASSIGN:
					case FLOORDIV_ASSIGN:
					case DIV_ASSIGN:
					case PLUS_ASSIGN:
					case MINUS_ASSIGN:
					case STAR_ASSIGN:
					case REM_ASSIGN:
					case MOD_ASSIGN:
					case POW_ASSIGN:
					case SR_ASSIGN:
					case SL_ASSIGN:
					case BXOR_ASSIGN:
					case BOR_ASSIGN:
					case BAND_ASSIGN:
					case EOL:
					{
						break;
					}
					default:
					{
						throw new NoViableAltException(LT(1), getFilename());
					}
					}
					}
					if ( inputState.guessing==0 ) {
						listPatt_AST = (AST)currentAST.root;
						listPatt_AST.setType(MapPattern);
					}
				}
				else if ((_tokenSet_36.member(LA(1))) && (_tokenSet_37.member(LA(2)))) {
					patternList();
					astFactory.addASTChild(currentAST, returnAST);
					match(RBRACK);
					{
					switch ( LA(1)) {
					case PLUS:
					{
						match(PLUS);
						listPatt();
						astFactory.addASTChild(currentAST, returnAST);
						break;
					}
					case EOF:
					case RCURLY:
					case LITERAL_in:
					case QUESTION:
					case RPAREN:
					case RBRACK:
					case LCURLY:
					case COMMA:
					case LOR:
					case LAND:
					case SEMI:
					case ASSIGN:
					case FLOORDIV_ASSIGN:
					case DIV_ASSIGN:
					case PLUS_ASSIGN:
					case MINUS_ASSIGN:
					case STAR_ASSIGN:
					case REM_ASSIGN:
					case MOD_ASSIGN:
					case POW_ASSIGN:
					case SR_ASSIGN:
					case SL_ASSIGN:
					case BXOR_ASSIGN:
					case BOR_ASSIGN:
					case BAND_ASSIGN:
					case EOL:
					{
						break;
					}
					default:
					{
						throw new NoViableAltException(LT(1), getFilename());
					}
					}
					}
					if ( inputState.guessing==0 ) {
						listPatt_AST = (AST)currentAST.root;
						listPatt_AST.setType(ListPattern);
					}
				}
				else {
					throw new NoViableAltException(LT(1), getFilename());
				}
				
				}
				listPatt_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_17);
			} else {
			  throw ex;
			}
		}
		returnAST = listPatt_AST;
	}
	
	public final void eqPatt() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST eqPatt_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case QUASIOPEN:
			case LITERAL_bind:
			case LITERAL_var:
			case LITERAL__:
			case LPAREN:
			case ATCURLY:
			case AT:
			case LAND:
			case IDENT:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				quasiPatt();
				astFactory.addASTChild(currentAST, returnAST);
				eqPatt_AST = (AST)currentAST.root;
				break;
			}
			case SAME:
			{
				AST tmp120_AST = null;
				tmp120_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp120_AST);
				match(SAME);
				prim();
				astFactory.addASTChild(currentAST, returnAST);
				eqPatt_AST = (AST)currentAST.root;
				break;
			}
			case NOTSAME:
			{
				AST tmp121_AST = null;
				tmp121_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp121_AST);
				match(NOTSAME);
				prim();
				astFactory.addASTChild(currentAST, returnAST);
				eqPatt_AST = (AST)currentAST.root;
				break;
			}
			case GE:
			case GT:
			case LE:
			case ABA:
			case LT:
			{
				compOp();
				astFactory.addASTChild(currentAST, returnAST);
				prim();
				astFactory.addASTChild(currentAST, returnAST);
				eqPatt_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_17);
			} else {
			  throw ex;
			}
		}
		returnAST = eqPatt_AST;
	}
	
	public final void key() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST key_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case LPAREN:
			{
				parenExpr();
				astFactory.addASTChild(currentAST, returnAST);
				key_AST = (AST)currentAST.root;
				break;
			}
			case HEX:
			case OCTAL:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case INT:
			case FLOAT64:
			{
				literal();
				astFactory.addASTChild(currentAST, returnAST);
				key_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_38);
			} else {
			  throw ex;
			}
		}
		returnAST = key_AST;
	}
	
	public final void mapPattList() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST mapPattList_AST = null;
		
		try {      // for error handling
			{
			switch ( LA(1)) {
			case HEX:
			case OCTAL:
			case LPAREN:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case INT:
			case FLOAT64:
			{
				key();
				astFactory.addASTChild(currentAST, returnAST);
				AST tmp122_AST = null;
				tmp122_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp122_AST);
				match(MAPSTO);
				{
				switch ( LA(1)) {
				case COMMA:
				{
					match(COMMA);
					mapPattList();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case RBRACK:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				break;
			}
			case RBRACK:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			mapPattList_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_39);
			} else {
			  throw ex;
			}
		}
		returnAST = mapPattList_AST;
	}
	
	public final void patternList() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST patternList_AST = null;
		
		try {      // for error handling
			{
			switch ( LA(1)) {
			case QUASIOPEN:
			case LITERAL_bind:
			case LITERAL_var:
			case LITERAL__:
			case LPAREN:
			case ATCURLY:
			case AT:
			case SAME:
			case NOTSAME:
			case GE:
			case GT:
			case LE:
			case ABA:
			case LT:
			case LAND:
			case IDENT:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				eqPatt();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case COMMA:
				{
					match(COMMA);
					patternList();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case RBRACK:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				break;
			}
			case RBRACK:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			patternList_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_39);
			} else {
			  throw ex;
			}
		}
		returnAST = patternList_AST;
	}
	
	public final void quasiPatt() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST quasiPatt_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case QUASIOPEN:
			{
				quasiString();
				astFactory.addASTChild(currentAST, returnAST);
				quasiPatt_AST = (AST)currentAST.root;
				break;
			}
			case LPAREN:
			{
				parenExpr();
				astFactory.addASTChild(currentAST, returnAST);
				quasiString();
				astFactory.addASTChild(currentAST, returnAST);
				quasiPatt_AST = (AST)currentAST.root;
				break;
			}
			default:
				if ((_tokenSet_40.member(LA(1))) && (_tokenSet_41.member(LA(2)))) {
					namer();
					astFactory.addASTChild(currentAST, returnAST);
					quasiPatt_AST = (AST)currentAST.root;
				}
				else {
					boolean synPredMatched105 = false;
					if (((LA(1)==IDENT) && (LA(2)==QUASIOPEN))) {
						int _m105 = mark();
						synPredMatched105 = true;
						inputState.guessing++;
						try {
							{
							match(IDENT);
							match(QUASIOPEN);
							}
						}
						catch (RecognitionException pe) {
							synPredMatched105 = false;
						}
						rewind(_m105);
						inputState.guessing--;
					}
					if ( synPredMatched105 ) {
						AST tmp125_AST = null;
						tmp125_AST = astFactory.create(LT(1));
						astFactory.addASTChild(currentAST, tmp125_AST);
						match(IDENT);
						quasiString();
						astFactory.addASTChild(currentAST, returnAST);
						quasiPatt_AST = (AST)currentAST.root;
					}
				else {
					throw new NoViableAltException(LT(1), getFilename());
				}
				}}
			}
			catch (RecognitionException ex) {
				if (inputState.guessing==0) {
					reportError(ex);
					consume();
					consumeUntil(_tokenSet_17);
				} else {
				  throw ex;
				}
			}
			returnAST = quasiPatt_AST;
		}
		
	public final void namer() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST namer_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case ATCURLY:
			case AT:
			case IDENT:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				nounExpr();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case COLON:
				{
					match(COLON);
					guard();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case EOF:
				case RCURLY:
				case LITERAL_in:
				case QUESTION:
				case RPAREN:
				case RBRACK:
				case LCURLY:
				case COMMA:
				case LOR:
				case LAND:
				case SEMI:
				case ASSIGN:
				case FLOORDIV_ASSIGN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case REM_ASSIGN:
				case MOD_ASSIGN:
				case POW_ASSIGN:
				case SR_ASSIGN:
				case SL_ASSIGN:
				case BXOR_ASSIGN:
				case BOR_ASSIGN:
				case BAND_ASSIGN:
				case EOL:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				if ( inputState.guessing==0 ) {
					namer_AST = (AST)currentAST.root;
					namer_AST.setType(FinalPattern);
				}
				namer_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL__:
			{
				AST tmp127_AST = null;
				tmp127_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp127_AST);
				match(LITERAL__);
				{
				switch ( LA(1)) {
				case COLON:
				{
					match(COLON);
					guard();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case EOF:
				case RCURLY:
				case LITERAL_in:
				case QUESTION:
				case RPAREN:
				case RBRACK:
				case LCURLY:
				case COMMA:
				case LOR:
				case LAND:
				case SEMI:
				case ASSIGN:
				case FLOORDIV_ASSIGN:
				case DIV_ASSIGN:
				case PLUS_ASSIGN:
				case MINUS_ASSIGN:
				case STAR_ASSIGN:
				case REM_ASSIGN:
				case MOD_ASSIGN:
				case POW_ASSIGN:
				case SR_ASSIGN:
				case SL_ASSIGN:
				case BXOR_ASSIGN:
				case BOR_ASSIGN:
				case BAND_ASSIGN:
				case EOL:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				if ( inputState.guessing==0 ) {
					namer_AST = (AST)currentAST.root;
					namer_AST.setType(IgnorePattern);
				}
				namer_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_bind:
			{
				binder();
				astFactory.addASTChild(currentAST, returnAST);
				namer_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL_var:
			{
				varNamer();
				astFactory.addASTChild(currentAST, returnAST);
				namer_AST = (AST)currentAST.root;
				break;
			}
			case LAND:
			{
				slotNamer();
				astFactory.addASTChild(currentAST, returnAST);
				namer_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_17);
			} else {
			  throw ex;
			}
		}
		returnAST = namer_AST;
	}
	
	public final void slotNamer() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST slotNamer_AST = null;
		
		try {      // for error handling
			AST tmp129_AST = null;
			tmp129_AST = astFactory.create(LT(1));
			astFactory.makeASTRoot(currentAST, tmp129_AST);
			match(LAND);
			nounExpr();
			astFactory.addASTChild(currentAST, returnAST);
			{
			switch ( LA(1)) {
			case COLON:
			{
				match(COLON);
				guard();
				astFactory.addASTChild(currentAST, returnAST);
				break;
			}
			case EOF:
			case RCURLY:
			case LITERAL_in:
			case QUESTION:
			case RPAREN:
			case RBRACK:
			case LCURLY:
			case COMMA:
			case LOR:
			case LAND:
			case SEMI:
			case ASSIGN:
			case FLOORDIV_ASSIGN:
			case DIV_ASSIGN:
			case PLUS_ASSIGN:
			case MINUS_ASSIGN:
			case STAR_ASSIGN:
			case REM_ASSIGN:
			case MOD_ASSIGN:
			case POW_ASSIGN:
			case SR_ASSIGN:
			case SL_ASSIGN:
			case BXOR_ASSIGN:
			case BOR_ASSIGN:
			case BAND_ASSIGN:
			case EOL:
			{
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
			}
			if ( inputState.guessing==0 ) {
				slotNamer_AST = (AST)currentAST.root;
				slotNamer_AST.setType(SlotPattern);
			}
			slotNamer_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_17);
			} else {
			  throw ex;
			}
		}
		returnAST = slotNamer_AST;
	}
	
	public final void dollarHole() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST dollarHole_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case 253:
			{
				AST tmp131_AST = null;
				tmp131_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp131_AST);
				match(253);
				AST tmp132_AST = null;
				tmp132_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp132_AST);
				match(LiteralInteger);
				AST tmp133_AST = null;
				tmp133_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp133_AST);
				match(RCURLY);
				dollarHole_AST = (AST)currentAST.root;
				break;
			}
			case 255:
			{
				AST tmp134_AST = null;
				tmp134_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp134_AST);
				match(255);
				AST tmp135_AST = null;
				tmp135_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp135_AST);
				match(LiteralInteger);
				dollarHole_AST = (AST)currentAST.root;
				break;
			}
			case 256:
			{
				AST tmp136_AST = null;
				tmp136_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp136_AST);
				match(256);
				dollarHole_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_16);
			} else {
			  throw ex;
			}
		}
		returnAST = dollarHole_AST;
	}
	
	public final void atHole() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST atHole_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case ATCURLY:
			{
				AST tmp137_AST = null;
				tmp137_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp137_AST);
				match(ATCURLY);
				AST tmp138_AST = null;
				tmp138_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp138_AST);
				match(POSINT);
				match(RCURLY);
				atHole_AST = (AST)currentAST.root;
				break;
			}
			case AT:
			{
				AST tmp140_AST = null;
				tmp140_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp140_AST);
				match(AT);
				AST tmp141_AST = null;
				tmp141_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp141_AST);
				match(POSINT);
				atHole_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_16);
			} else {
			  throw ex;
			}
		}
		returnAST = atHole_AST;
	}
	
	public final void mapPattern() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST mapPattern_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case HEX:
			case OCTAL:
			case LPAREN:
			case CHAR_LITERAL:
			case STRING_LITERAL:
			case INT:
			case FLOAT64:
			{
				key();
				astFactory.addASTChild(currentAST, returnAST);
				AST tmp142_AST = null;
				tmp142_AST = astFactory.create(LT(1));
				astFactory.makeASTRoot(currentAST, tmp142_AST);
				match(MapsTo);
				pattern();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case ASSIGN:
				{
					AST tmp143_AST = null;
					tmp143_AST = astFactory.create(LT(1));
					astFactory.addASTChild(currentAST, tmp143_AST);
					match(ASSIGN);
					order();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case EOF:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				mapPattern_AST = (AST)currentAST.root;
				break;
			}
			case MapsTo:
			{
				AST tmp144_AST = null;
				tmp144_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp144_AST);
				match(MapsTo);
				namer();
				astFactory.addASTChild(currentAST, returnAST);
				{
				switch ( LA(1)) {
				case ASSIGN:
				{
					AST tmp145_AST = null;
					tmp145_AST = astFactory.create(LT(1));
					astFactory.addASTChild(currentAST, tmp145_AST);
					match(ASSIGN);
					order();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case EOF:
				{
					break;
				}
				default:
				{
					throw new NoViableAltException(LT(1), getFilename());
				}
				}
				}
				mapPattern_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_0);
			} else {
			  throw ex;
			}
		}
		returnAST = mapPattern_AST;
	}
	
/**
 * The name pattern, or literal name, for an object definition
 * expression
 */
	public final void oName() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST oName_AST = null;
		
		try {      // for error handling
			switch ( LA(1)) {
			case ATCURLY:
			case AT:
			case IDENT:
			case 249:
			case 251:
			case 252:
			case 253:
			case 255:
			case 256:
			{
				nounExpr();
				astFactory.addASTChild(currentAST, returnAST);
				oName_AST = (AST)currentAST.root;
				break;
			}
			case LITERAL__:
			{
				AST tmp146_AST = null;
				tmp146_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp146_AST);
				match(LITERAL__);
				oName_AST = (AST)currentAST.root;
				break;
			}
			case BIND:
			{
				AST tmp147_AST = null;
				tmp147_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp147_AST);
				match(BIND);
				noun();
				astFactory.addASTChild(currentAST, returnAST);
				oName_AST = (AST)currentAST.root;
				break;
			}
			case VAR:
			{
				AST tmp148_AST = null;
				tmp148_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp148_AST);
				match(VAR);
				nounExpr();
				astFactory.addASTChild(currentAST, returnAST);
				oName_AST = (AST)currentAST.root;
				break;
			}
			case STRING_LITERAL:
			{
				AST tmp149_AST = null;
				tmp149_AST = astFactory.create(LT(1));
				astFactory.addASTChild(currentAST, tmp149_AST);
				match(STRING_LITERAL);
				oName_AST = (AST)currentAST.root;
				break;
			}
			default:
			{
				throw new NoViableAltException(LT(1), getFilename());
			}
			}
		}
		catch (RecognitionException ex) {
			if (inputState.guessing==0) {
				reportError(ex);
				consume();
				consumeUntil(_tokenSet_0);
			} else {
			  throw ex;
			}
		}
		returnAST = oName_AST;
	}
	
	
	public static final String[] _tokenNames = {
		"<0>",
		"EOF",
		"<2>",
		"NULL_TREE_LOOKAHEAD",
		"QUASIOPEN",
		"QUASICLOSE",
		"QUASIBODY",
		"QuasiContent",
		"\"}\"",
		"QIDENT",
		"HEX",
		"OCTAL",
		"\"bind\"",
		"\"break\"",
		"\"catch\"",
		"\"continue\"",
		"\"def\"",
		"\"else\"",
		"\"escape\"",
		"\"extends\"",
		"\"finally\"",
		"\"for\"",
		"\"guards\"",
		"\"if\"",
		"\"implements\"",
		"\"in\"",
		"\"interface\"",
		"\"match\"",
		"\"meta\"",
		"\"method\"",
		"\"pragma\"",
		"\"return\"",
		"\"switch\"",
		"\"thunk\"",
		"\"to\"",
		"\"try\"",
		"\"var\"",
		"\"when\"",
		"\"while\"",
		"\"_\"",
		"\"accum\"",
		"\"delegate\"",
		"\"module\"",
		"\"on\"",
		"\"select\"",
		"\"throws\"",
		"\"abstract\"",
		"\"an\"",
		"\"as\"",
		"\"assert\"",
		"\"attribute\"",
		"\"be\"",
		"\"begin\"",
		"\"behalf\"",
		"\"belief\"",
		"\"believe\"",
		"\"believes\"",
		"\"case\"",
		"\"class\"",
		"\"const\"",
		"\"constructor\"",
		"\"declare\"",
		"\"default\"",
		"\"define\"",
		"\"defmacro\"",
		"\"delicate\"",
		"\"deprecated\"",
		"\"dispatch\"",
		"\"do\"",
		"\"encapsulate\"",
		"\"encapsulated\"",
		"\"encapsulates\"",
		"\"end\"",
		"\"ensure\"",
		"\"enum\"",
		"\"eventual\"",
		"\"eventually\"",
		"\"export\"",
		"\"facet\"",
		"\"forall\"",
		"\"function\"",
		"\"given\"",
		"\"hidden\"",
		"\"hides\"",
		"\"inline\"",
		"\"is\"",
		"\"know\"",
		"\"knows\"",
		"\"lambda\"",
		"\"let\"",
		"\"methods\"",
		"\"namespace\"",
		"\"native\"",
		"\"obeys\"",
		"\"octet\"",
		"\"oneway\"",
		"\"operator\"",
		"\"package\"",
		"\"private\"",
		"\"protected\"",
		"\"public\"",
		"\"raises\"",
		"\"reliance\"",
		"\"reliant\"",
		"\"relies\"",
		"\"rely\"",
		"\"reveal\"",
		"\"sake\"",
		"\"signed\"",
		"\"static\"",
		"\"struct\"",
		"\"suchthat\"",
		"\"supports\"",
		"\"suspect\"",
		"\"suspects\"",
		"\"synchronized\"",
		"\"this\"",
		"\"transient\"",
		"\"truncatable\"",
		"\"typedef\"",
		"\"unsigned\"",
		"\"unum\"",
		"\"uses\"",
		"\"using\"",
		"\"utf8\"",
		"\"utf16\"",
		"\"virtual\"",
		"\"volatile\"",
		"\"wstring\"",
		"QUESTION",
		"LPAREN",
		"RPAREN",
		"LBRACK",
		"RBRACK",
		"LCURLY",
		"DOLLARCURLY",
		"ATCURLY",
		"AT",
		"COLON",
		"COMMA",
		"DOT",
		"THRU",
		"TILL",
		"SAME",
		"LNOT",
		"BNOT",
		"NOTSAME",
		"DIV",
		"FLOORDIV",
		"PLUS",
		"INC",
		"MINUS",
		"DEC",
		"STAR",
		"REM",
		"MOD",
		"SR",
		"GE",
		"GT",
		"SL",
		"LE",
		"ABA",
		"LT",
		"BXOR",
		"BOR",
		"LOR",
		"BAND",
		"BUTNOT",
		"LAND",
		"SEMI",
		"POW",
		"ASSIGN",
		"FLOORDIV_ASSIGN",
		"DIV_ASSIGN",
		"PLUS_ASSIGN",
		"MINUS_ASSIGN",
		"STAR_ASSIGN",
		"REM_ASSIGN",
		"MOD_ASSIGN",
		"POW_ASSIGN",
		"SR_ASSIGN",
		"SL_ASSIGN",
		"BXOR_ASSIGN",
		"BOR_ASSIGN",
		"BAND_ASSIGN",
		"SEND",
		"WHEN",
		"MAPSTO",
		"MATCHBIND",
		"MISMATCH",
		"SCOPE",
		"WS",
		"EOL",
		"SL_COMMENT",
		"ML_COMMENT",
		"CHAR_LITERAL",
		"STRING_LITERAL",
		"ESC",
		"HEX_DIGIT",
		"IDENT",
		"INT",
		"POSINT",
		"FLOAT64",
		"EXPONENT",
		"RunExpr",
		"GetExpr",
		"AssignExpr",
		"CallExpr",
		"DefineExpr",
		"EscapeExpr",
		"HideExpr",
		"IfExpr",
		"ForExpr",
		"LiteralExpr",
		"MatchBindExpr",
		"NounExpr",
		"ObjectExpr",
		"QuasiLiteralExpr",
		"QuasiPatternExpr",
		"MetaStateExpr",
		"MetaContextExpr",
		"SeqExpr",
		"SlotExpr",
		"MetaExpr",
		"CatchExpr",
		"FinallyExpr",
		"ReturnExpr",
		"ContinueExpr",
		"BreakExpr",
		"WhileExpr",
		"SwitchExpr",
		"TryExpr",
		"MapPattern",
		"TupleExpr",
		"BindPattern",
		"SendExpr",
		"FinalPattern",
		"VarPattern",
		"SlotPattern",
		"ListPattern",
		"CdrPattern",
		"IgnorePattern",
		"SuchThatPattern",
		"QuasiLiteralPattern",
		"QuasiPatternPattern",
		"EScript",
		"EMethod",
		"EMatcher",
		"XOR",
		"\"%\"",
		"LiteralString",
		"\"%%\"",
		"\"::\"",
		"\"${\"",
		"LiteralInteger",
		"\"$\"",
		"\"$$\"",
		"MapsTo",
		"BIND",
		"VAR"
	};
	
	protected void buildTokenTypeASTClassMap() {
		tokenTypeToASTClassMap=null;
	};
	
	private static final long[] mk_tokenSet_0() {
		long[] data = { 2L, 0L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_0 = new BitSet(mk_tokenSet_0());
	private static final long[] mk_tokenSet_1() {
		long[] data = new long[10];
		data[0]=1071739419922L;
		data[2]=1406109451124L;
		data[3]=-4971973988617026152L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_1 = new BitSet(mk_tokenSet_1());
	private static final long[] mk_tokenSet_2() {
		long[] data = { 258L, 0L, 8L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_2 = new BitSet(mk_tokenSet_2());
	private static final long[] mk_tokenSet_3() {
		long[] data = new long[8];
		data[0]=258L;
		data[2]=2199023257640L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_3 = new BitSet(mk_tokenSet_3());
	private static final long[] mk_tokenSet_4() {
		long[] data = new long[10];
		data[0]=618475294736L;
		data[2]=1131187307284L;
		data[3]=-5044031582654955392L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_4 = new BitSet(mk_tokenSet_4());
	private static final long[] mk_tokenSet_5() {
		long[] data = new long[10];
		data[0]=1071605201968L;
		data[2]=10202202474358L;
		data[3]=-72057594037925991L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_5 = new BitSet(mk_tokenSet_5());
	private static final long[] mk_tokenSet_6() {
		long[] data = new long[8];
		data[3]=1873497444986126464L;
		return data;
	}
	public static final BitSet _tokenSet_6 = new BitSet(mk_tokenSet_6());
	private static final long[] mk_tokenSet_7() {
		long[] data = new long[8];
		data[0]=258L;
		data[2]=2199023257704L;
		data[3]=288230376151711745L;
		return data;
	}
	public static final BitSet _tokenSet_7 = new BitSet(mk_tokenSet_7());
	private static final long[] mk_tokenSet_8() {
		long[] data = new long[8];
		data[0]=258L;
		data[2]=2199023257704L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_8 = new BitSet(mk_tokenSet_8());
	private static final long[] mk_tokenSet_9() {
		long[] data = new long[10];
		data[0]=519701863440L;
		data[2]=274922144596L;
		data[3]=-5044031582654954088L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_9 = new BitSet(mk_tokenSet_9());
	private static final long[] mk_tokenSet_10() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3746994889951083646L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_10 = new BitSet(mk_tokenSet_10());
	private static final long[] mk_tokenSet_11() {
		long[] data = new long[10];
		data[0]=33554706L;
		data[2]=4323455642254507134L;
		data[3]=1L;
		data[4]=2L;
		return data;
	}
	public static final BitSet _tokenSet_11 = new BitSet(mk_tokenSet_11());
	private static final long[] mk_tokenSet_12() {
		long[] data = new long[8];
		data[0]=168968450L;
		data[2]=3746994889951083646L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_12 = new BitSet(mk_tokenSet_12());
	private static final long[] mk_tokenSet_13() {
		long[] data = { 33554432L, 0L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_13 = new BitSet(mk_tokenSet_13());
	private static final long[] mk_tokenSet_14() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=144109827956672616L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_14 = new BitSet(mk_tokenSet_14());
	private static final long[] mk_tokenSet_15() {
		long[] data = new long[8];
		data[0]=258L;
		data[2]=144108591006091368L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_15 = new BitSet(mk_tokenSet_15());
	private static final long[] mk_tokenSet_16() {
		long[] data = new long[8];
		data[0]=33554706L;
		data[2]=3746994889951083646L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_16 = new BitSet(mk_tokenSet_16());
	private static final long[] mk_tokenSet_17() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=144109827956672618L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_17 = new BitSet(mk_tokenSet_17());
	private static final long[] mk_tokenSet_18() {
		long[] data = new long[8];
		data[0]=258L;
		data[2]=144108728445044840L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_18 = new BitSet(mk_tokenSet_18());
	private static final long[] mk_tokenSet_19() {
		long[] data = new long[8];
		data[0]=258L;
		data[2]=144109827956672616L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_19 = new BitSet(mk_tokenSet_19());
	private static final long[] mk_tokenSet_20() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875269490444392L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_20 = new BitSet(mk_tokenSet_20());
	private static final long[] mk_tokenSet_21() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875301165829224L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_21 = new BitSet(mk_tokenSet_21());
	private static final long[] mk_tokenSet_22() {
		long[] data = new long[10];
		data[0]=450982317072L;
		data[2]=274922144596L;
		data[3]=-5044031582654954088L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_22 = new BitSet(mk_tokenSet_22());
	private static final long[] mk_tokenSet_23() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875269490444394L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_23 = new BitSet(mk_tokenSet_23());
	private static final long[] mk_tokenSet_24() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875301165853800L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_24 = new BitSet(mk_tokenSet_24());
	private static final long[] mk_tokenSet_25() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875303581772904L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_25 = new BitSet(mk_tokenSet_25());
	private static final long[] mk_tokenSet_26() {
		long[] data = { 0L, 0L, 236453888L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_26 = new BitSet(mk_tokenSet_26());
	private static final long[] mk_tokenSet_27() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875303592258664L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_27 = new BitSet(mk_tokenSet_27());
	private static final long[] mk_tokenSet_28() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602875303828712552L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_28 = new BitSet(mk_tokenSet_28());
	private static final long[] mk_tokenSet_29() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3602879701875223656L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_29 = new BitSet(mk_tokenSet_29());
	private static final long[] mk_tokenSet_30() {
		long[] data = new long[8];
		data[0]=33554690L;
		data[2]=3746994889951083644L;
		data[3]=1L;
		return data;
	}
	public static final BitSet _tokenSet_30 = new BitSet(mk_tokenSet_30());
	private static final long[] mk_tokenSet_31() {
		long[] data = { 0L, 0L, 4L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_31 = new BitSet(mk_tokenSet_31());
	private static final long[] mk_tokenSet_32() {
		long[] data = { 0L, 0L, 40L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_32 = new BitSet(mk_tokenSet_32());
	private static final long[] mk_tokenSet_33() {
		long[] data = new long[10];
		data[0]=33554690L;
		data[2]=4323455642254507134L;
		data[3]=1L;
		data[4]=2L;
		return data;
	}
	public static final BitSet _tokenSet_33 = new BitSet(mk_tokenSet_33());
	private static final long[] mk_tokenSet_34() {
		long[] data = new long[8];
		data[0]=3072L;
		data[2]=36L;
		data[3]=1304L;
		return data;
	}
	public static final BitSet _tokenSet_34 = new BitSet(mk_tokenSet_34());
	private static final long[] mk_tokenSet_35() {
		long[] data = new long[10];
		data[0]=521882942738L;
		data[2]=720570923901717374L;
		data[3]=-4971973988617026151L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_35 = new BitSet(mk_tokenSet_35());
	private static final long[] mk_tokenSet_36() {
		long[] data = new long[10];
		data[0]=618475294736L;
		data[2]=1131187307300L;
		data[3]=-5044031582654955392L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_36 = new BitSet(mk_tokenSet_36());
	private static final long[] mk_tokenSet_37() {
		long[] data = new long[10];
		data[0]=521882942770L;
		data[2]=144110102878818174L;
		data[3]=-72057594037925991L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_37 = new BitSet(mk_tokenSet_37());
	private static final long[] mk_tokenSet_38() {
		long[] data = new long[10];
		data[2]=576460752303423488L;
		data[4]=2L;
		return data;
	}
	public static final BitSet _tokenSet_38 = new BitSet(mk_tokenSet_38());
	private static final long[] mk_tokenSet_39() {
		long[] data = { 0L, 0L, 32L, 0L, 0L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_39 = new BitSet(mk_tokenSet_39());
	private static final long[] mk_tokenSet_40() {
		long[] data = new long[10];
		data[0]=618475294720L;
		data[2]=1099511628544L;
		data[3]=-5044031582654955392L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_40 = new BitSet(mk_tokenSet_40());
	private static final long[] mk_tokenSet_41() {
		long[] data = new long[10];
		data[0]=33554690L;
		data[2]=144109827956674410L;
		data[3]=-144115188075855231L;
		data[4]=1L;
		return data;
	}
	public static final BitSet _tokenSet_41 = new BitSet(mk_tokenSet_41());
	
	}
