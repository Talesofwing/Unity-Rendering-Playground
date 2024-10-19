using System.Collections.Generic;
using UnityEngine;

public class OutlineObjectManager : MonoBehaviour
{
    [SerializeField]
    private GameObject[] _allObjects;

    private List<GameObject> _outlineObjects = new List<GameObject>();

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                GameObject hitGo = hit.collider.gameObject;

                if (Input.GetKey(KeyCode.LeftControl) || Input.GetKey(KeyCode.RightControl))
                {
                    if (_outlineObjects.Contains(hitGo))
                    {
                        _outlineObjects.Remove(hitGo);
                    }
                    else
                    {
                        _outlineObjects.Add(hitGo);
                    }
                }
                else
                {
                    if (!_outlineObjects.Contains(hitGo))
                    {
                        _outlineObjects.Clear();
                        _outlineObjects.Add(hitGo);
                    }
                    else
                    {
                        _outlineObjects.Clear();
                    }
                }
            }
            else
            {
                _outlineObjects.Clear();
            }
        }

        SetOutline();
    }

    private void SetOutline()
    {
        foreach (GameObject go in _allObjects)
        {
            go.GetComponent<OutlineObject>().enabled = false;
        }

        foreach (GameObject go in _outlineObjects)
        {
            go.GetComponent<OutlineObject>().enabled = true;
        }
    }
}
