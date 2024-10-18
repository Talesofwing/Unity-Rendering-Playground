using System.Collections.Generic;
using UnityEngine;

public class GrassHandler : MonoBehaviour
{
    [SerializeField]
    private Transform _grassRoot;
    [SerializeField]
    private float _windScale = 3.0f;

    private List<MeshRenderer> _grasses = new List<MeshRenderer>();

    private void Awake()
    {
        for (int i = 0; i < _grassRoot.childCount; ++i)
        {
            _grasses.Add(_grassRoot.GetChild(i).GetComponent<MeshRenderer>());
        }
    }

    private void Start()
    {
        RandomWind();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            RandomWind();
        }
    }

    private void RandomWind()
    {
        for (int i = 0; i < _grasses.Count; ++i)
        {
            _grasses[i].material.SetVector("_Wind", GetRandomWindDirection() * _windScale);
        }
    }

    private Vector4 GetRandomWindDirection()
    {
        return new Vector4(Random.Range(0.0f, 1.0f), 0, Random.Range(0.0f, 1.0f), 0).normalized;
    }

}
