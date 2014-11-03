// reflective bump test 2
// By ren712


#define GENERATE_NORMALS   
#include "mta-helper.fx"

texture sReflectionTexture;
float xval=0.28;
float yval=0.30;
float bFac =0.24;
float xzoom = 1;
float yzoom =0.78;
float brFac =0.5; // 0.32
float efInte=0.7; // 0.56

sampler2D envMap = sampler_state
{
    Texture = (sReflectionTexture);
	AddressU = Mirror;
	AddressV = Mirror;
	AddressW = Mirror;
	MinFilter = Anisotropic;
	MagFilter = Anisotropic;
	MipFilter = Linear;
	MaxAnisotropy = 4;
	
};

sampler2D baseMap = sampler_state
{
	Texture = (gTexture0);
	AddressU = Wrap;
	AddressV = Wrap;
	AddressW = Wrap;
	MinFilter = Anisotropic;
	MagFilter = Anisotropic;
	MipFilter = Linear;
	MaxAnisotropy = 4;
};


struct VS_INPUT 
{
	float4 Position : POSITION0;
	float4 Color : 	 COLOR0;
	float2 Texcoord : TEXCOORD0;
	float3 Normal :   NORMAL0; 
};

struct VS_OUTPUT 
{
	float4 Position :        POSITION0;
	float2 Texcoord :        TEXCOORD0;
	float3 TexCoord_proj:    TEXCOORD1;
	float3 LightDirection:   TEXCOORD2;
	float4 Diffuse:   		 TEXCOORD3;
	float DistFade:          TEXCOORD4;
};

VS_OUTPUT vertex_shader( VS_INPUT Input )
{
	VS_OUTPUT Output;
	MTAFixUpNormal( Input.Normal );
   
	Output.Position = mul(Input.Position, gWorldViewProjection);
	Output.Texcoord = Input.Texcoord;
	float3 worldPosition =mul(float4(Input.Position.xyz,1), gWorld).xyz;
  
   	float4 Po = float4(Input.Position.xyz,1.0);
	float4 pPos = mul(Po, gWorldViewProjection); 

	Output.TexCoord_proj.x = 0.5 * (pPos.w + pPos.x);
	Output.TexCoord_proj.y = 0.5 * (pPos.w - pPos.y);
	Output.TexCoord_proj.z = pPos.w;
   
	float3 LightDir=(1.0f, 1.0, 0.8f);
	Output.LightDirection = normalize(LightDir);
	
	float DistanceFromCamera = MTACalcCameraDistance( gCameraPosition, worldPosition );
	Output.DistFade = MTAUnlerp ( 190, 110, DistanceFromCamera );
	Output.Diffuse = MTACalcGTABuildingDiffuse( Input.Color );
	return( Output );
}


struct PS_INPUT 
{
	float2 Texcoord :        TEXCOORD0;
	float3 TexCoord_proj:    TEXCOORD1;
	float3 LightDirection:   TEXCOORD2;
	float4 Diffuse:   		 TEXCOORD3;
	float DistFade:          TEXCOORD4;
};

// The Sobel filter extracts the first order derivates of the image,
// that is, the slope. The slope in X and Y directon allows us to
// given a heightmap evaluate the normal for each pixel. This is
// the same this as ATI's NormalMapGenerator application does,
// except this is in hardware.
//
// These are the filter kernels:
//
//  SobelX       SobelY
//  1  0 -1      1  2  1
//  2  0 -2      0  0  0
//  1  0 -1     -1 -2 -1

float3 ComputeNormalsPS(in float2 uv:TEXCOORD0) : COLOR
{
	float textureSize = 512.0f;
	float normalStrength = 5;
    float texelSize =  1.0f / textureSize ; //size of one texel
    
    float tl = abs(tex2D (baseMap, uv + texelSize * float2(-1, -1)).x);   
    float  l = abs(tex2D (baseMap, uv + texelSize * float2(-1,  0)).x);  
    float bl = abs(tex2D (baseMap, uv + texelSize * float2(-1,  1)).x);  
    float  t = abs(tex2D (baseMap, uv + texelSize * float2( 0, -1)).x);
    float  b = abs(tex2D (baseMap, uv + texelSize * float2( 0,  1)).x); 
    float tr = abs(tex2D (baseMap, uv + texelSize * float2( 1, -1)).x);  
    float  r = abs(tex2D (baseMap, uv + texelSize * float2( 1,  0)).x); 
    float br = abs(tex2D (baseMap, uv + texelSize * float2( 1,  1)).x);  
	
    float dX = tr + 2*r + br -tl - 2*l - bl; 
    float dY = bl + 2*b + br -tl - 2*t - tr; 
	
    float3 N = float3(normalize(float3(dX, 1.0f / normalStrength, dY)));
    return N * 0.5f + 0.5f;
}

float4 pixel_shader( PS_INPUT Input ) : COLOR0
{   
   float3 fvNormal         = ComputeNormalsPS(Input.Texcoord);
   float  fNDotL           = dot( fvNormal, Input.LightDirection ); 
   float3 sTexture  = float3((Input.TexCoord_proj.xy / Input.TexCoord_proj.z),0) ;
   sTexture-=pow(fNDotL,bFac);
   sTexture.xy+=float2(xval,yval);
   sTexture.xy*=float2(xzoom,yzoom);
   float4 texel = tex2D(envMap,sTexture)*(brFac);
   float lum = (texel.r + texel.g + texel.b)/3;
   float adj = saturate( lum - 0.1 );
   adj = adj / (1.01 - 0.3);
   texel = texel * adj;
   texel+=0.17;
   float4 fvBaseColor      = tex2D( baseMap, Input.Texcoord )*Input.Diffuse;
   float4 fvTotalAmbient   = saturate((fvBaseColor)/1.4); 
   float4 fvTotalDiffuse= (Input.Diffuse *texel)*efInte;

   float4 outPut=saturate(fvTotalAmbient*fNDotL) +saturate(Input.DistFade)*fvTotalDiffuse;  
   outPut.a=fvBaseColor.a;
   return outPut;
}

technique reflective_bump_test2sm3
{
    pass P0
    {
        VertexShader = compile vs_3_0 vertex_shader();
        PixelShader = compile ps_3_0 pixel_shader();
    }
}

technique reflective_bump_test2sm2
{
    pass P0
    {
        VertexShader = compile vs_2_0 vertex_shader();
        PixelShader = compile ps_2_0 pixel_shader();
    }
}
