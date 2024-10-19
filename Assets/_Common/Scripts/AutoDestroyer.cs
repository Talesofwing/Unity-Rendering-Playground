using UnityEngine;

public class AutoDestroyer : MonoBehaviour
{
    [SerializeField]
    float _delay = 1.0f;

    private void Awake()
    {
        Invoke("DestroySelf", _delay);
    }

    private void DestroySelf()
    {
        Destroy(this.gameObject);
    }
}
