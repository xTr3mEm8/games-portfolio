using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class DisplayLevel : MonoBehaviour
{
    // Start is called before the first frame update

    public Text Level;

    public static int curLevel = 1;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Level.text = "Level " + curLevel.ToString();
    }
}
