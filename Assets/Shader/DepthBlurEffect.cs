using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode, RequireComponent(typeof(Camera))]
public class DepthBlurEffect : MonoBehaviour
{
    public Material blurMaterial;
    private int onlyonce = 0;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (blurMaterial)
        {
            //depthBlurMaterial.SetFloat("_HitDepth", hitDepth);
            //depthBlurMaterial.SetFloat("_ClearRadius", clearRadius);
            blurMaterial.SetPass(0);
            Graphics.Blit(source, destination, blurMaterial);
        }
        else
        {
            blurMaterial.SetPass(0);
            Graphics.Blit(source, destination);
        }
    }
}
