using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BackToMainMenu : MonoBehaviour
{
    public string scenename;


    private void Update()
    {
        if (Input.GetKey(KeyCode.M))
        {

            SceneManager.LoadScene("Main Menu");
        }
        if (Input.GetKey(KeyCode.Escape))
        {

            Application.Quit();

        }
    }
}
