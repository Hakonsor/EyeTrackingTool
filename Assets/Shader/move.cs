using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public float moveSpeed = 5.0f;

    void Update()
    {
        // Get input for camera movement using WASD
        float horizontalInput = Input.GetAxis("Horizontal");
        float verticalInput = Input.GetAxis("Vertical");

        // Calculate new camera position
        Vector3 moveDirection = new Vector3(horizontalInput, 0.0f, verticalInput);
        Vector3 newPosition = transform.position + moveDirection * moveSpeed * Time.deltaTime;

        // Update the camera's position
        transform.position = newPosition;
    }

}
