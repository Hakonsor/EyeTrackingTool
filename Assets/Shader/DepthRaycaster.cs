using UnityEngine;
using static OVRPlugin;

public class DepthRaycaster : MonoBehaviour
{
    public LayerMask raycastLayers;
    public float rayDistance = 1000f;
    [HideInInspector]
    public float hitDepth = -1f;

    public Camera leftEyeCam;
    public Camera rightEyeCam;

    private void Update()
    {
        float leftEyeDepth = CastRayFromCamera(leftEyeCam);
        float rightEyeDepth = CastRayFromCamera(rightEyeCam);

        // Average the depths or choose based on some other logic
        hitDepth = (leftEyeDepth + rightEyeDepth) / 2f;
    }

    private float CastRayFromCamera(Camera cam)
    {
        Ray ray = new Ray(transform.position, cam.transform.position - transform.position);
        if (Physics.Raycast(ray, out RaycastHit hit, rayDistance, raycastLayers))
        {
            return cam.WorldToViewportPoint(hit.point).z;
        }
        return -1f; // Reset to default value if no hit
    }
}
