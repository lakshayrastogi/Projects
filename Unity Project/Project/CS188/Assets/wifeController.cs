using UnityEngine;
using System.Collections;

public class wifeController : MonoBehaviour {

	enum SceneState { ToSon, Wait, ToDoor, InsideDialogue, End };

	private SceneState currentState = SceneState.ToSon;

	private GameObject sonRef;
	private sonController sonControllerRef;

	private GameObject cameras;
	private cameraController ccref;

	public Vector3[] ToDoorPoints;
	public float ToDoorSpeed;
	private int ToDoorIndex;

	public Vector3[] ToSonPoints;
	public float ToSonSpeed;
	private int ToSonIndex;

	// Use this for initialization
	void Start () {
		sonRef = GameObject.Find("Son");
		sonControllerRef = sonRef.GetComponent<sonController>();
		cameras = GameObject.Find ("cameras");
		ccref = cameras.GetComponent<cameraController> ();
	}

	// Update is called once per frame
	void Update () {
		// Execute behavior based on state
		switch (currentState)
		{
		// Walk up to the front door
		case SceneState.ToDoor:
			if (MoveTo(ToDoorPoints[ToDoorIndex], ToDoorSpeed))
			{
				ToDoorIndex++;
//				if (ToSonIndex == ToSonPoints.Length - 2) {
//					GameObject.Find ("Camera (2)").GetComponent<Camera> ().enabled = false;
//					GameObject.Find ("DoorCam").GetComponent<Camera> ().enabled = true;
					//					ccref.cameras [0].enabled = false;
					//					ccref.cameras [3].enabled = true;
//				}
				if (ToDoorIndex == ToDoorPoints.Length)
				{
					currentState = SceneState.InsideDialogue;
					GameObject.Find ("DoorCam").GetComponent<Camera> ().enabled = false;
					GameObject.Find ("Camera").GetComponent<Camera> ().enabled = true;
				}
			}
			break;

		case SceneState.InsideDialogue:
			break;

			// Wait at the door for Jim to welcome Kate inside
		case SceneState.Wait:
			break;

			// Move toward the couch
		case SceneState.ToSon:
			if (MoveTo(ToSonPoints[ToSonIndex], ToSonSpeed))
			{
				ToSonIndex++;
				if (ToSonIndex == ToSonPoints.Length - 1) {
					GameObject.Find ("Main Camera").GetComponent<Camera> ().enabled = false;
					GameObject.Find ("Camera (2)").GetComponent<Camera> ().enabled = true;
//					ccref.cameras [0].enabled = false;
//					ccref.cameras [3].enabled = true;
				}
				if (ToSonIndex == ToSonPoints.Length)
				{
					currentState = SceneState.Wait;
					sonControllerRef.SetNextState();
				}
			}
			break;

			// Scene end
		case SceneState.End:
			break;
		}
	}

	// Traverse to next state when invoked by another script
	public void SetNextState()
	{
		switch (currentState)
		{
		// Called some time after Jim opens the door
		case SceneState.Wait:
			currentState = SceneState.ToDoor;
			break;
		}
	}

	// Move toward a target point at a given speed in units per second.
	// Returns true if we have reached our target, and false otherwise.
	bool MoveTo(Vector3 targetPos, float speed)
	{
		float step = speed * Time.deltaTime;
		transform.position = Vector3.MoveTowards(transform.position, targetPos, step);

		return (transform.position == targetPos);
	}
}
