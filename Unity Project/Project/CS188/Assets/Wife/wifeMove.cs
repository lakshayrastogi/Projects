using UnityEngine;
using System.Collections;

public class wifeMove : MonoBehaviour {

	// Use this for initialization
	void Start () {
		StartCoroutine (movement1());
		iTween.MoveTo (gameObject, iTween.Hash ("path", iTweenPath.GetPath ("son"), "time", 10));
	}
		
	IEnumerator movement1()
	{
		iTween.MoveTo(gameObject, iTween.Hash("path", iTweenPath.GetPath("wife1"), "time", 5, "onComplete", "movement1temp", "onCompleteTarget", gameObject));
		yield return new WaitForSeconds (1);
	}

	void movement1temp()
	{
	}	

	// Update is called once per frame
	void Update () {
	
	}
}
