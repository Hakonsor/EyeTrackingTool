Shader"Hidden/DepthShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Focus ("Focus", Float) = 0.0 
        _HitX ("HitY", Float) = 0.0 
        _HitY ("HitX", Float) = 0.0 
    }
    SubShader
    {

        Tags { "Queue"="Transparent" }
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID 
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            UNITY_DECLARE_SCREENSPACE_TEXTURE( _MainTex);
            UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture);
            float _Focus;
            float _HitY;
            float _HitX;


            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                float4 col = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv);

                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv).r;

                float threshold = 0.1f;
                float2 hitPoint = float2(_HitX, _HitY);
                float distanceFromHit = distance(i.uv, hitPoint);
               //if(_Focus > depth) {
               //     return col;
               // }

                if (_Focus < depth ) 
                {
                    return col;
                }
                //float noe = abs((1-_Focus) - depth)
                return depth ;
                
                

                
                //float blurRadius = distanceFromHit * 0.05; // Increase blur based on distance

                //if (abs(_Focus - depth) < threshold && distanceFromHit < 0.2 ) 
                //{
                //    // The pixel is at the focus depth, render it in color
                //    return col;
                //}
                //else
                //{
                //    // Apply blur effect
                //    float4 blurredColor = float4(0, 0, 0, 0);
                //    int samples = 9; // Total number of samples (3x3 kernel)
                //    for (int x = -1; x <= 1; x++)
                //    {
                //        for (int y = -1; y <= 1; y++)
                //        {
                //            float2 sampleUV = i.uv + float2(x, y) * blurRadius;
                //            blurredColor += UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, sampleUV);
                //        }
                //    }
                //    blurredColor /= samples;

                //    return blurredColor;
   
                // }
                 }
            ENDCG
        }
    }
}
