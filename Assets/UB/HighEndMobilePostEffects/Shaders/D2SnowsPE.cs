//#define DEBUG_RENDER

using UnityEngine;
using System.Collections;
using System.Linq;
using System.Runtime.InteropServices;

namespace UB
{
    [ExecuteInEditMode]
    public class D2SnowsPE : EffectBase
    {
        public Color Color = new Color(1f, 1f, 1f, 1f);
        [Range(1,50)]
        public float ParticleMultiplier = 10.0f;
        public float Speed = 4.0f;
        public float Direction = 0.2f;
        [Range(0.01f, 5)]
        public float Zoom = 1.2f;
        private Shader Shader;
        private Material _material;

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (Shader == null)
            {
                Shader = Shader.Find("UB/PostEffects/D2Snows");
            }

            if (_material)
            {
                DestroyImmediate(_material);
                _material = null;
            }
            if (Shader)
            {
                _material = new Material(Shader);
                _material.hideFlags = HideFlags.HideAndDontSave;

                if (_material.HasProperty("_Color"))
                {
                    _material.SetColor("_Color", Color);
                }
                if (_material.HasProperty("_Speed"))
                {
                    _material.SetFloat("_Speed", Speed);
                }
                if (_material.HasProperty("_Direction"))
                {
                    _material.SetFloat("_Direction", Direction);
                }
                if (_material.HasProperty("_Zoom"))
                {
                    _material.SetFloat("_Zoom", Zoom);
                }
                if (_material.HasProperty("_Multiplier"))
                {
                    _material.SetFloat("_Multiplier", ParticleMultiplier);
                }
            }

            if (Shader != null && _material != null)
            {
                Graphics.Blit(source, destination, _material);
            }
        }
    }
}