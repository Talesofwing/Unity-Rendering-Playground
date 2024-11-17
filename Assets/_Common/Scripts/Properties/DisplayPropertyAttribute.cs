using UnityEngine;

public class DisplayPropertyAttribute : PropertyAttribute
{
    public string EnumFieldName { get; }
    public int EnumValue { get; }

    public DisplayPropertyAttribute(string enumFieldName, int enumValue)
    {
        EnumFieldName = enumFieldName;
        EnumValue = enumValue;
    }
}
