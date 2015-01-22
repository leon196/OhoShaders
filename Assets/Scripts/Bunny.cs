using UnityEngine;
using System.Collections;

public class Bunny : MonoBehaviour {

	public float rotationSpeed = 30f;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Vector3.up * Time.deltaTime * rotationSpeed);
	}
}
