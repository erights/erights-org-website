// $ANTLR 2.7.4: "quasi.g" -> "QuasiParser.java"$

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

public class QuasiParser extends antlr.LLkParser       implements quasiTokenTypes
 {

protected QuasiParser(TokenBuffer tokenBuf, int k) {
  super(tokenBuf,k);
  tokenNames = _tokenNames;
  buildTokenTypeASTClassMap();
  astFactory = new ASTFactory(getTokenTypeToASTClassMap());
}

public QuasiParser(TokenBuffer tokenBuf) {
  this(tokenBuf,1);
}

protected QuasiParser(TokenStream lexer, int k) {
  super(lexer,k);
  tokenNames = _tokenNames;
  buildTokenTypeASTClassMap();
  astFactory = new ASTFactory(getTokenTypeToASTClassMap());
}

public QuasiParser(TokenStream lexer) {
  this(lexer,1);
}

public QuasiParser(ParserSharedInputState state) {
  super(state,1);
  tokenNames = _tokenNames;
  buildTokenTypeASTClassMap();
  astFactory = new ASTFactory(getTokenTypeToASTClassMap());
}

	public final void quasiContent() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST quasiContent_AST = null;
		
		try {      // for error handling
			{
			_loop3:
			do {
				switch ( LA(1)) {
				case QUASIBODY:
				{
					AST tmp1_AST = null;
					tmp1_AST = astFactory.create(LT(1));
					astFactory.addASTChild(currentAST, tmp1_AST);
					match(QUASIBODY);
					break;
				}
				case QIDENT:
				{
					AST tmp2_AST = null;
					tmp2_AST = astFactory.create(LT(1));
					astFactory.addASTChild(currentAST, tmp2_AST);
					match(QIDENT);
					break;
				}
				case DOLLARCURLY:
				{
					exprHole();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				case ATCURLY:
				{
					pattHole();
					astFactory.addASTChild(currentAST, returnAST);
					break;
				}
				default:
				{
					break _loop3;
				}
				}
			} while (true);
			}
			quasiContent_AST = (AST)currentAST.root;
			quasiContent_AST = (AST)astFactory.make( (new ASTArray(2)).add(astFactory.create(QuasiContent)).add(quasiContent_AST));
			currentAST.root = quasiContent_AST;
			currentAST.child = quasiContent_AST!=null &&quasiContent_AST.getFirstChild()!=null ?
				quasiContent_AST.getFirstChild() : quasiContent_AST;
			currentAST.advanceChildToEnd();
			quasiContent_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			reportError(ex);
			consume();
			consumeUntil(_tokenSet_0);
		}
		returnAST = quasiContent_AST;
	}
	
	public final void exprHole() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST exprHole_AST = null;
		
		try {      // for error handling
			match(DOLLARCURLY);
			exprHole_AST = (AST)currentAST.root;
			EParser p = new EParser(getInputState());
			p.eExpr();
			exprHole_AST = p.getAST();
			eMain.OurSelector.pop();
			
			currentAST.root = exprHole_AST;
			currentAST.child = exprHole_AST!=null &&exprHole_AST.getFirstChild()!=null ?
				exprHole_AST.getFirstChild() : exprHole_AST;
			currentAST.advanceChildToEnd();
			AST tmp4_AST = null;
			tmp4_AST = astFactory.create(LT(1));
			astFactory.addASTChild(currentAST, tmp4_AST);
			match(RCURLY);
			exprHole_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			reportError(ex);
			consume();
			consumeUntil(_tokenSet_1);
		}
		returnAST = exprHole_AST;
	}
	
	public final void pattHole() throws RecognitionException, TokenStreamException {
		
		returnAST = null;
		ASTPair currentAST = new ASTPair();
		AST pattHole_AST = null;
		
		try {      // for error handling
			match(ATCURLY);
			pattHole_AST = (AST)currentAST.root;
			EParser p = new EParser(getInputState());
			p.pattern();
			pattHole_AST = p.getAST();
			eMain.OurSelector.pop();
			
			currentAST.root = pattHole_AST;
			currentAST.child = pattHole_AST!=null &&pattHole_AST.getFirstChild()!=null ?
				pattHole_AST.getFirstChild() : pattHole_AST;
			currentAST.advanceChildToEnd();
			AST tmp6_AST = null;
			tmp6_AST = astFactory.create(LT(1));
			astFactory.addASTChild(currentAST, tmp6_AST);
			match(RCURLY);
			pattHole_AST = (AST)currentAST.root;
		}
		catch (RecognitionException ex) {
			reportError(ex);
			consume();
			consumeUntil(_tokenSet_1);
		}
		returnAST = pattHole_AST;
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
		"DOLLARCURLY",
		"ATCURLY",
		"DOLLARESC",
		"QINT"
	};
	
	protected void buildTokenTypeASTClassMap() {
		tokenTypeToASTClassMap=null;
	};
	
	private static final long[] mk_tokenSet_0() {
		long[] data = { 2L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_0 = new BitSet(mk_tokenSet_0());
	private static final long[] mk_tokenSet_1() {
		long[] data = { 3650L, 0L};
		return data;
	}
	public static final BitSet _tokenSet_1 = new BitSet(mk_tokenSet_1());
	
	}
