package data_structure;

public class Symbol implements Comparable<Symbol>
{
    private Integer code;
    private String atom;

    public Symbol(Integer code, String atom)
    {
        this.code = code;
        this.atom = atom;
    }

    @Override
    public int compareTo(Symbol o)
    {
        return this.code.compareTo(o.code);
    }

    public Integer getCode()
    {
        return code;
    }

    public String getAtom()
    {
        return atom;
    }

    @Override
    public String toString()
    {
        return "code\t" + code + "\tatom\t" + atom;
    }

}
