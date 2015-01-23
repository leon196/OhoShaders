using UnityEngine;
using System.Collections;

public class Flat : MonoBehaviour {

	// Use this for initialization
	void Start () {
	            //---the following mesh code is an optional stylisation code
            //---to make mesh force "flat shading"(flat retro shadows)....
            Mesh mesh = GetComponent<MeshFilter>().mesh;
            Vector3[] myvertices = mesh.vertices;
            int[] mytriangles = mesh.triangles;
            Vector3[] mynormals = new Vector3[mytriangles.Length];
            Vector3[] newvertices = new Vector3[mytriangles.Length];     
            Vector2[] newUVs =  new Vector2[mytriangles.Length];
           
            for (int TR = 0; TR < mytriangles.Length ; TR ++){ 
                newvertices[TR] = myvertices[mytriangles[TR]];
                mynormals[TR] = mesh.normals[mytriangles[TR]];         
                mytriangles[TR] = TR;
               
                      // sry i didnt reweite the UV's like for you,  it should be possible to copy each uv from old vertex same as the nromals/
     
            }
            mesh.vertices = newvertices;
            mesh.triangles = mytriangles;
                    mesh.normals = mynormals;
            mesh.uv = newUVs;

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
