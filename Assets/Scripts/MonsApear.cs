using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsApear : MonoBehaviour
{
    public GameObject monster;
    public Collider collision1;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            monster.SetActive(true);
            collision1.enabled = false;
        }
    }
}
