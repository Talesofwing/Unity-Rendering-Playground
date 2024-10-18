using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField]
    private Vector3 _rotation = new Vector3(0, 45, 0);

    private void Update()
    {
        transform.Rotate(_rotation * Time.deltaTime);
    }
}
