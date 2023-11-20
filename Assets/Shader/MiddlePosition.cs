using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MiddlePosition : MonoBehaviour
{
    public GameObject Eye1;
    public GameObject Eye2;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        var pos1 = Eye1.transform.position;
        var pos2 = Eye2.transform.position;
        var rot = Eye1.transform.rotation;

        var center = ((pos1 + pos2) * 0.5f);
        transform.position = center;
        transform.rotation = rot;
    }
}