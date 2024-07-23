using UnityEngine;

public class WallTriggerScript : MonoBehaviour
{
    public Animator wallAnimator; // Drag your wall's Animator component here in the Inspector

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player")) // Assuming the player has the tag "Player"
        {
            wallAnimator.SetTrigger("MoveWall");
        }
    }
}
