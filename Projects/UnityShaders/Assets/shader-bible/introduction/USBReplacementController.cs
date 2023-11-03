using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class USBReplacementController : MonoBehaviour
{
    public Shader m_replacementShader;

    public void OnEnable()
    {
        if (m_replacementShader != null)
        {
            GetComponent<Camera>().SetReplacementShader(m_replacementShader, "RenderType");
        }
    }

    public void OnDisable()
    {
       GetComponent<Camera>().ResetReplacementShader();
    }
}
