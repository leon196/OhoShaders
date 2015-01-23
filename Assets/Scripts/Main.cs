using UnityEngine;
using System.Collections;

public class Main : MonoBehaviour {


	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		Shader.SetGlobalFloat("timeElapsed", Time.time);
		Shader.SetGlobalVector("cameraPosition", new Vector4(
			Camera.main.transform.position.x,
			Camera.main.transform.position.y,
			Camera.main.transform.position.z,
			0f));
		Shader.SetGlobalVector("cameraDirection", Camera.main.transform.forward);
	}
}
