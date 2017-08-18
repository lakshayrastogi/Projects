using UnityEngine;
using System.Collections;

public class SonMove : MonoBehaviour {

	// Use this for initialization
	void Start () {
		StartCoroutine (movement1());
		iTween.MoveTo (gameObject, iTween.Hash ("path", iTweenPath.GetPath ("son"), "time", 10));
	}

	IEnumerator movement1()
	{
		yield return new WaitForSeconds (1);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
