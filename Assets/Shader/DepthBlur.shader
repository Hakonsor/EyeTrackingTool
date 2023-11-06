Shader"Custom/DepthBlur"
{
        Properties
        {
            _MainTex("Screen Texture", 2D) = "white" {}
            _DepthTex("Depth Texture", 2D) = "white" {}
            _MaxDepth("Max Depth", Range(0, 1)) = 0.5
            _BlurSize("Blur Size", Range(0, 0.1)) = 0.005
        }

        SubShader
        {
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
        sampler2D _DepthTex;

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
            float depth = tex2D(_DepthTex, i.uv).r;

                        // Blur amount based on depth
            float blurAmount = depth > _MaxDepth ? _BlurSize : 0;
        
                        // Blur in X and Y
            float4 col = tex2D(_MainTex, i.uv);
            col += tex2D(_MainTex, i.uv + float2(blurAmount, 0));
            col += tex2D(_MainTex, i.uv + float2(-blurAmount, 0));
            col += tex2D(_MainTex, i.uv + float2(0, blurAmount));
            col += tex2D(_MainTex, i.uv + float2(0, -blurAmount));

            return col / 5.0;
        }
            ENDCG
        }
    }
}
