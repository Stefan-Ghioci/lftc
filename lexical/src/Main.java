import algorithm.Analyser;

import java.io.File;
import java.util.List;

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
            List<String> symbols = analyser.getSymbols();
            for (int i = 0; i < symbols.size(); i++)
            {
                System.out.println("index\t" + i + "\tvalue  " + symbols.get(i));
            }

        }
        catch (Exception e)
        {
            System.out.println("ERROR:" + e.getMessage());
        }

    }
}
