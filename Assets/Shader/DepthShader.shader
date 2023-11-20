Shader"Hidden/DepthShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Focal ("Focal", Float) = 1.0
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
            float _Focal;
            //float _HitY;
            //float _HitX;


            fixed4 frag (v2f i) : SV_Target
            {
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                    float4 col = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv);
                    float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv).r;
               
                    float a = 1000;
                    float b = 0.1;
                    float nonLinearDepth = 1.0 / (a * depth + b);
                    float distance = _Focal/1000;
 
                    float distanceMin = 0.002;
                    float distanceMax = 0.014;
                    float nonLinearDepthMin = 0.006;
                    float nonLinearDepthMax = 0.04;

                    float normalizedDistance = saturate((distance - distanceMin) / (distanceMax - distanceMin));
                    float normalizedNonLinearDepth = saturate((nonLinearDepth - nonLinearDepthMin) / (nonLinearDepthMax - nonLinearDepthMin));
                    if(abs(normalizedDistance - normalizedNonLinearDepth) > 0.15){
                   
                        float2 texelSize = 1.0 / _ScreenParams.xy;
                        float4 col = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv);

                        // Apply a 7x7 Box Blur for a stronger effect
                        float3 blurredColor = float3(0, 0, 0);

                        for (int x = -3; x <= 3; x++) { // Increased the loop boundaries to -3 and 3
                            for (int y = -3; y <= 3; y++) { // Increased the loop boundaries to -3 and 3
                                float2 offset = float2(x, y) * texelSize;
                                float4 nearbyCol = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv + offset);
                                blurredColor += nearbyCol.rgb;
                            }
                        }

                        blurredColor /= 49.0; // Increased the divisor to 49 (7x7 kernel)

                        return float4(blurredColor, 1.0);
                    }
                    return col;

  
                 }
            ENDCG
        }
    }
}
