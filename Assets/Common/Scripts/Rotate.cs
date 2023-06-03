using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour {
    [SerializeField] private Vector3 _rotation = new Vector3 (0, 45, 0);


    private Transform _cacheTf;
    public Transform CacheTf {
        get {
            if (null == _cacheTf)
                _cacheTf = this.transform;

            return _cacheTf;
        }
    }

    private void Update () {
        CacheTf.Rotate (_rotation * Time.deltaTime);
    }

}
