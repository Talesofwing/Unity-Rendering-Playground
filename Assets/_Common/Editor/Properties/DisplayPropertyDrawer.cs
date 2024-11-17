using UnityEngine;
using UnityEditor;

[CustomPropertyDrawer(typeof(DisplayPropertyAttribute))]
public class DisplayPropertyDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        DisplayPropertyAttribute ins = (DisplayPropertyAttribute)attribute;
        SerializedProperty enumField = property.serializedObject.FindProperty(ins.EnumFieldName);

        if (enumField != null && enumField.enumValueIndex == ins.EnumValue)
        {
            EditorGUI.PropertyField(position, property, label);
        }
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        DisplayPropertyAttribute ins = (DisplayPropertyAttribute)attribute;
        SerializedProperty enumField = property.serializedObject.FindProperty(ins.EnumFieldName);

        if (enumField != null && enumField.enumValueIndex == ins.EnumValue)
        {
            return EditorGUI.GetPropertyHeight(property, label);
        }
        else
        {
            return 0;
        }
    }
}
