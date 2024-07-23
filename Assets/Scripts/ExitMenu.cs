using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ExitMenu : MonoBehaviour
{
    public string scenename;
    

    private void Update()
    {
        if (Input.GetKey(KeyCode.P))
        {

            SceneManager.LoadScene("Game");
        }
        if (Input.GetKey(KeyCode.Escape))
        {

            Application.Quit();

        }
    }
}
