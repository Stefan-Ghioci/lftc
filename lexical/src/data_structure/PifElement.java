package data_structure;

public class PifElement
{
    private Integer code;
    private Integer key;
    private Type type;
    private String desc;

    public PifElement(Integer code, Integer key, Type type, String desc)
    {
        this.code = code;
        this.key = key;
        this.type = type;
        this.desc = desc;
    }

    @Override
    public String toString()
    {
        return
                "code " + code + "\tkey  " + (key == -1 ? "-" : key) + "\ttype  " + type + "\tdesc  " + desc;
    }
}
