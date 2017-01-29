import java.io.*;
import antlr.BaseAST;
import antlr.DumpASTVisitor;
import antlr.TokenStreamSelector;
import antlr.collections.AST;

class eMain {
    static public TokenStreamSelector OurSelector;
    public static void main(String[] args) {
        try {
            //ELexer lexer = new ELexer (new DataInputStream(System.in));
            ELexer eLexer = new ELexer(new DataInputStream(new FileInputStream("example.e")));
            QuasiLexer qlexer = new QuasiLexer(eLexer.getInputState());
            TokenStreamSelector selector = new TokenStreamSelector();
            OurSelector = selector; 
            eLexer.addToSelector(selector, "e");
            qlexer.addToSelector(selector,"quasi");
            selector.select("e");
            EParser parser = new EParser(selector);
            for (int i = 0, max = 10; i < max; i++) {
                //System.out.print("? ");
                parser.start();
                System.out.println();
                //System.out.println("#");
                AST results = parser.getAST();
                BaseAST.setVerboseStringConversion(true, EParser._tokenNames);
                DumpASTVisitor visitor = new DumpASTVisitor();
                visitor.visit(results);
                System.out.println(results == null ? "NULL" : results.toStringTree());
            }
            //System.out.println("...done.");
        } catch(Exception e) {
            System.err.println("exception: "+e);
        }
    }
}