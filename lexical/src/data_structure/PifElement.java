package data_structure;

public class PifElement
{
    private Integer code;
    private Integer key;
    private Type type;

    public PifElement(Integer code, Integer key, Type type)
    {
        this.code = code;
        this.key = key;
        this.type = type;
    }

    @Override
    public String toString()
    {
        return
                "code " + code + "\tkey\t" + key + "\ttype  " + type;
    }
}
