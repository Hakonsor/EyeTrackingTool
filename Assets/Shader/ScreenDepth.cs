using OculusSampleFramework;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static OVRPlugin;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ScreenDepth : MonoBehaviour
{
    public Camera cam;
    public Material material;
    public GameObject eyeright;
    public GameObject eyeleft;
    public bool onlyonce = false;
    public float raydistance = 1000.0f;
    public LayerMask raycastLayers = -1;
        private List<float> lastFiveDistances = new List<float>();

    void Update()
    {
        if (cam == null)
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.Depth;
        }

        if (material == null)
            material = new Material(Shader.Find("Hidden/DepthShader"));


        if (cam.depthTextureMode != DepthTextureMode.Depth)
            cam.depthTextureMode = DepthTextureMode.Depth;


        // Define the ray directions from both eyes
        Vector3 rightFront = eyeright.transform.forward * 10;
        Vector3 leftFront = eyeleft.transform.forward * 10;
        //Debug.Log("rightFront" + rightFront);
        //Debug.Log("leftFront" + leftFront);
        // Calculate the midpoint between the two ray directions
        Vector3 midpoint = (rightFront + leftFront) / 2;

        //Debug.Log("midpoint" + midpoint);
        // Calculate the midpoint between the eye positions
        Vector3 eyeMidpoint = (eyeright.transform.position + eyeleft.transform.position) / 2;
        //Debug.Log("midpoint" + midpoint);
        // Create a ray starting from the midpoint between the two ray directions and going towards the eye midpoint
        Ray ray = new Ray(eyeMidpoint, midpoint);

        if (Physics.Raycast(ray, out RaycastHit hit, raydistance, -1))
        {
            // Calculate the distance from the hit point to the midpoint between the eyes
            float distance = Vector3.Distance(eyeMidpoint, hit.point);

            // Send the distance to the shader
            material.SetFloat("_Focal", distance);
            Debug.Log("Distance set to " + material.GetFloat("_Focal"));
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}