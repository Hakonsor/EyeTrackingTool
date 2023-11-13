using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ScreenDepth : MonoBehaviour
{
    public Camera cam;
    public Material material;
    public GameObject eye;

    public float raydistance = 1000.0f;
    public LayerMask raycastLayers = -1;
        private List<float> lastFiveDistances = new List<float>();

    void Update()
    {
        if (cam == null)
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.DepthNormals;
        }

        if (material == null)
            material = new Material(Shader.Find("Hidden/DepthShader"));


        if (cam.depthTextureMode != DepthTextureMode.DepthNormals)
            cam.depthTextureMode = DepthTextureMode.DepthNormals;

        Ray ray = new Ray(eye.transform.position, eye.transform.forward);
        if (Physics.Raycast(ray, out RaycastHit hit, raydistance, raycastLayers))
        {
            var viewportPoint = cam.WorldToViewportPoint(hit.point);
            var viewportDepth = viewportPoint.z;
            var distance = cam.WorldToViewportPoint(hit.point).z/cam.farClipPlane;
            material.SetFloat("_HitX", viewportPoint.x);
            material.SetFloat("_HitY", viewportPoint.y);

            // Store the last five distances
            lastFiveDistances.Add(distance);
            if (lastFiveDistances.Count > 5)
            {
                lastFiveDistances.RemoveAt(0); // Remove the oldest distance
            }

            // Calculate and set the median value
            if (lastFiveDistances.Count == 5)
            {
                float median = lastFiveDistances.Max();
                material.SetFloat("_Focus", median);
            }
        }
        else
        {
            material.SetFloat("_Focus", 0.0f);
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