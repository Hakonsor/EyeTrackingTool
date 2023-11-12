Shader"Custom/DepthBlur"
{
        Properties
        {
            _MainTex("Screen Texture", 2D) = "white" {}
            _DepthTex("Depth Texture", 2D) = "white" {}
            //_MaxDepth("Max Depth", Range(0, 1)) = 0.5
            //_BlurSize("Blur Size", Range(0, 0.1)) = 0.005
        }

        SubShader
        {
            Tags { "Queue"="Transparent" }
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

        sampler2D _MainTex;
        //sampler2D _DepthTex;
        sampler2D _CameraDepthNormalsTexture;

        float _MaxDepth;
        float _BlurSize;

        v2f vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            return o;
        }

        float4 frag(v2f i) : SV_Target
        {
            float4 col = tex2D(_MainTex, i.uv);
            return col;
            //float4 NormalDepth;
            //DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv), NormalDepth.w, NormalDepth.xyz);
            ////col.rgb = NormalDepth.w;
            //col.rgb = NormalDepth.xyz;
            //return col;
    //float depth = tex2D(_DepthTex, i.uv).r;
    //float normalizedDepth = depth / _MaxDepth;
    //float remappedDepth = normalizedDepth * 255.0;

    //        // Debug visualization by outputting normalizedDepth as color
    //return float4(normalizedDepth, normalizedDepth, normalizedDepth, 1.0);
            // Retrieve the depth value from the depth texture
            //float depth = tex2D(_DepthTex, i.uv).r;

            //// Ensure that depth is within expected range
            //if (depth < 0 || depth > _MaxDepth)
            //{
            //    // If depth is out of range, color it as red
            //    return float4(1.0, 0.0, 0.0, 1.0);
            //}

            //// Normalize the depth value to the 0-1 range based on _MaxDepth
            //float normalizedDepth = depth / _MaxDepth;

            //// Remap the normalized depth to the 0-255 range
            //float remappedDepth = normalizedDepth * 255.0;

            //// Debug visualization by outputting remappedDepth as color
            //return float4(remappedDepth / 255.0, 0.0, 0.0, 1.0);
            //float depth = tex2D(_DepthTex, i.uv).r;
            //float normalizedDepth = depth / _MaxDepth;
            //float remappedDepth = normalizedDepth * 255.0;

            //// Debug visualization by outputting normalizedDepth as color
            //return float4(normalizedDepth, normalizedDepth, normalizedDepth, 1.0);
            
            //            // Blur in X and Y
            //float4 col = tex2D(_MainTex, i.uv);
            //col += tex2D(_MainTex, i.uv + float2(blurAmount, 0));
            //col += tex2D(_MainTex, i.uv + float2(-blurAmount, 0));
            //col += tex2D(_MainTex, i.uv + float2(0, blurAmount));
            //col += tex2D(_MainTex, i.uv + float2(0, -blurAmount));

            //return col / 5.0;
        }
            ENDCG
        }
    }
}
