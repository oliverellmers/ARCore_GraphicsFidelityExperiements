﻿//#define DEBUG_RENDER

using UnityEngine;
using System.Collections;
using System.Linq;
using System.Runtime.InteropServices;

namespace UB
{
    [ExecuteInEditMode]
    public class D2RainsPE : EffectBase
    {
        public Color Color = new Color(1f, 1f, 1f, 1f);
        public Texture2D Noise;
        public float Density = 1.4f;
        public float Speed = 0.1f;
        public float Exposure = 5f;
        public float Direction = -0.32f;

        private Shader Shader;
        private Material _material;

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (Shader == null)
            {
                Shader = Shader.Find("UB/PostEffects/D2Rains");
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
                if (_material.HasProperty("_NoiseTex"))
                {
                    _material.SetTexture("_NoiseTex", Noise);
                }
                if (_material.HasProperty("_Density"))
                {
                    _material.SetFloat("_Density", Density);
                }
                if (_material.HasProperty("_Speed"))
                {
                    _material.SetFloat("_Speed", Speed);
                }
                if (_material.HasProperty("_Exposure"))
                {
                    _material.SetFloat("_Exposure", Exposure);
                }
                if (_material.HasProperty("_Direction"))
                {
                    _material.SetFloat("_Direction", Direction);
                }
            }

            if (Shader != null && _material != null)
            {
                Graphics.Blit(source, destination, _material);
            }
        }
    }
}