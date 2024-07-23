using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Monsterattack : MonoBehaviour
{
    public Rigidbody monsRigid;
    public Transform monsTrans, playerTrans;
    public int monSpeed;

    private void FixedUpdate()
    {
        monsRigid.velocity = transform.forward * monSpeed * Time.deltaTime;
    }

    private void Update()
    {
        monsTrans.LookAt(playerTrans);
    }


}
