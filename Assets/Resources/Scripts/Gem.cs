using UnityEngine;
using System.Collections;

public class Gem : MonoBehaviour

    
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(transform.position.x < -25)
        {
            Destroy(gameObject);
        }
        else
        {
            transform.Translate(-SkyscraperSpawner.speed * Time.deltaTime, 0, 0, Space.World);
        }

        transform.Rotate(0, 5f, 0, Space.World);

    }

    void OnTriggerEnter(Collider other)
    {
        other.transform.parent.GetComponent<HeliController>().PickUpGem();
        Destroy(gameObject);
    }
}
