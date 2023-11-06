using UnityEngine;

[ExecuteInEditMode, RequireComponent(typeof(OVRCameraRig))]
public class DepthBlurEffectOculus : MonoBehaviour
{
    public Material blurMaterial;
    private OVRCameraRig cameraRig;

    private void Start()
    {
        cameraRig = GetComponent<OVRCameraRig>();
        if (cameraRig)
        {
            cameraRig.leftEyeCamera.GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
            cameraRig.rightEyeCamera.GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
            cameraRig.leftEyeCamera.GetComponent<Camera>().targetTexture.wrapMode = TextureWrapMode.Clamp;
            cameraRig.rightEyeCamera.GetComponent<Camera>().targetTexture.wrapMode = TextureWrapMode.Clamp;
        }
    }

    void OnPostRender()
    {
        if (blurMaterial && cameraRig)
        {
            blurMaterial.SetPass(0);
            Graphics.Blit(null, cameraRig.leftEyeCamera.targetTexture, blurMaterial);
            Graphics.Blit(null, cameraRig.rightEyeCamera.targetTexture, blurMaterial);
        }
    }
}
