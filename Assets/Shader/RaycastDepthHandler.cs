using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthRayCastrer : MonoBehaviour
{
    public Material depthBlurMaterial; // The custom shader material to handle the depth blur
    public float clearRadius = 0.1f; // The radius within which things will be clear

    private DepthRaycaster[] sphereRaycasters;

    private void Start()
    {
        sphereRaycasters = FindObjectsOfType<DepthRaycaster>(); // Find all SphereRaycaster objects in the scene
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (depthBlurMaterial && sphereRaycasters.Length > 0)
        {
            // For simplicity, we'll just consider the first sphere's hit depth for now.
            // More advanced handling would be to consider all hit depths and handle them in the shader.
            depthBlurMaterial.SetFloat("_HitDepth", sphereRaycasters[0].hitDepth);
            depthBlurMaterial.SetFloat("_ClearRadius", clearRadius);
            Graphics.Blit(source, destination, depthBlurMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
