using System.Collections.Generic;
using System.Linq;
using UnityEngine;

//[ExecuteInEditMode]
//[RequireComponent(typeof(Camera))]
public class ScreenDepth : MonoBehaviour
{
    public Camera cam;
    private Material material;
    public GameObject eye;

    public float raydistance = 1000.0f;
    public LayerMask raycastLayers = -1;
    private List<float> lastFiveDistances = new();

    void Awake()
    {
        material = new Material(Shader.Find("Hidden/DepthShader2"));
        //cam = eye.GetComponentInParent<Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;
    }

    void Update()
    {

        /*
        if (material == null)
         if (cam == null)
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.Depth;
        }


        if (cam.depthTextureMode != DepthTextureMode.Depth)
            cam.depthTextureMode = DepthTextureMode.Depth;

        */

        var ray = new Ray(eye.transform.position, eye.transform.forward);
        if (Physics.Raycast(ray, out var hit, raydistance, raycastLayers))
        {
            var viewportPoint = eye.transform.InverseTransformPoint(hit.point);
            //var distance = viewportPoint.z;
            //var distance = viewportPoint.z / cam.farClipPlane;
            //var distance = hit.distance / 100.0f;
            var distance = Vector3.Distance(eye.transform.position, hit.point);
            Debug.Log($"Hit: {hit.point}, view: {viewportPoint}, distance: {distance}");
            material.SetFloat("_HitX", viewportPoint.x);
            material.SetFloat("_HitY", viewportPoint.y);
            material.SetFloat("_Focus", distance);

        }
        else
        {
            material.SetFloat("_Focus", 0.0f);
        }
    }   

    private void OnRenderImage(Texture source, RenderTexture destination)
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