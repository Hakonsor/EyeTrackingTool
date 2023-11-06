using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode, RequireComponent(typeof(Camera))]
public class DepthBlurEffect : MonoBehaviour
{
    public Material blurMaterial;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (blurMaterial)
        {
            Graphics.Blit(source, destination, blurMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
