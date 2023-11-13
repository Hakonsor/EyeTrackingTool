Shader"Hidden/DepthShader1"
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CameraDepthNormalsTexture;
            float _Focus;
            float _HitY;
            float _HitX;


            fixed4 frag (v2f i) : SV_Target
            {
                
                float4 col = tex2D(_MainTex, i.uv);

                float4 depthnormal = tex2D(_CameraDepthNormalsTexture, i.uv);
                
                float3 normal;
                float depth;
                DecodeDepthNormal(depthnormal, depth, normal);
                float threshold = 0.01f;

                float2 hitPoint = float2(_HitX, _HitY);
                float distanceFromHit = distance(i.uv, hitPoint);
                float blurRadius = distanceFromHit * 0.05; // Increase blur based on distance

                if (abs(_Focus - depth) < threshold && distanceFromHit < 0.2 ) 
                {
                    // The pixel is at the focus depth, render it in color
                    return col;
                }
                else
                {
                    // Apply blur effect
                    float4 blurredColor = float4(0, 0, 0, 0);
                    int samples = 9; // Total number of samples (3x3 kernel)
                    for (int x = -1; x <= 1; x++)
                    {
                        for (int y = -1; y <= 1; y++)
                        {
                            float2 sampleUV = i.uv + float2(x, y) * blurRadius;
                            blurredColor += tex2D(_MainTex, sampleUV);
                        }
                    }
                    blurredColor /= samples;

                    return blurredColor;
   
                 }
                 }
            ENDCG
        }
    }
}
