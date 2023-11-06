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
            var cam1 = cameraRig.leftEyeCamera.GetComponent<Camera>().depthTextureMode;
            cam1  |= DepthTextureMode.Depth;
            var cam12 = cameraRig.rightEyeCamera.GetComponent<Camera>().depthTextureMode;
            cam12 |= DepthTextureMode.Depth;
            //cameraRig.leftEyeCamera.GetComponent<Camera>().targetTexture.wrapMode = TextureWrapMode.Clamp;
            //cameraRig.rightEyeCamera.GetComponent<Camera>().targetTexture.wrapMode = TextureWrapMode.Clamp;
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
