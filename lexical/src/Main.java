import algorithm.Analyser;

import java.io.File;

public class Main
{

    public static void main(String[] args)
    {
        File input = new File(args[0]);
        Analyser analyser = null;
        analyser = new Analyser(input);

        try
        {
            analyser.analyse();

            System.out.println("------PROGRAM INTERNAL FORM------");
            analyser.getProgramInternalForm().forEach(System.out::println);


            System.out.println("----------SYMBOLS TABLE----------");
            analyser.getSymbols().printInOrder();

        }
        catch (Exception e)
        {
            System.out.println("ERROR:" + e.getMessage());
        }

    }
}
