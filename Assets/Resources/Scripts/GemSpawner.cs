using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour
{

    public GameObject[] prefabs;

    // Start is called before the first frame update
    void Start()
    {

        StartCoroutine(SpawnGems());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator SpawnGems()
    {
        while (true)
        {
            int gemsThisRow = Random.Range(1, 2);

            for (int i = 0; i < gemsThisRow; ++i)
            {
                Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
            }
            yield return new WaitForSeconds(Random.Range(2, 3));
        }

    }
}
