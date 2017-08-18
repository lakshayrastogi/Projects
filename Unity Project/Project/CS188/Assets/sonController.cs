using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class sonController : MonoBehaviour {

	enum SceneState { WaitForWife, Dialogue1, Dialogue2, ToDoor, InsideDialogue1, InsideDialogue2, End };

	private SceneState currentState = SceneState.WaitForWife;

	public Text DialogueText;

	private GameObject wifeRef;
	private wifeController wifeControllerRef;
	private GameObject fatherRef;
	private fatherController fatherControllerRef;

	private float waitTimer = 0.0f;
	public float WaitTime = 0.2f;

	public Vector3[] ToDoorPoints;
	public float ToDoorSpeed;
	private int ToDoorIndex;

	// Use this for initialization
	void Start () {
		wifeRef = GameObject.Find("Wife");
		wifeControllerRef = wifeRef.GetComponent<wifeController>();
		fatherRef = GameObject.Find ("Father");
		fatherControllerRef = fatherRef.GetComponent<fatherController> ();
	}

	// Update is called once per frame
	void Update () {
		// Execute behavior based on state
		switch (currentState)
		{
		// Move toward the door and open it for Kate
		//		case SceneState.ToDoor:
		//			if (MoveTo(ToDoorPoint, ToDoorSpeed))
		//			{
		//				currentState = SceneState.Wait;
		//				DoorControllerRef.OpenDoor();
		//				DialogueText.text = "Jim: Hello!";
		//			}
		//			break;

		// Wait a certain amount of time after opening the door, then welcome Kate inside
		case SceneState.WaitForWife:
			break;

		case SceneState.Dialogue1:
			DialogueText.text = "Wife: Your father is annoying. He keeps everything dirty and just sits around all day";
			waitTimer += Time.deltaTime;
			if (waitTimer >= WaitTime)
			{
				currentState = SceneState.Dialogue2;
				waitTimer = 0.0f;
			}
			break;

		case SceneState.Dialogue2:
			DialogueText.text = "Son: Yeah. I'm getting tired of his antics. Lets see what the old oaf is upto right now.";
			waitTimer += Time.deltaTime;
			if (waitTimer >= WaitTime)
			{
				GameObject.Find ("Camera (2)").GetComponent<Camera> ().enabled = false;
				GameObject.Find ("DoorCam").GetComponent<Camera> ().enabled = true;
				DialogueText.text = "";
				currentState = SceneState.ToDoor;
				wifeControllerRef.SetNextState();
				waitTimer = 0.0f;
			}
			break;

			// Move toward the couch
		case SceneState.ToDoor:
			if (MoveTo(ToDoorPoints[ToDoorIndex], ToDoorSpeed))
			{
				ToDoorIndex++;
				if (ToDoorIndex == ToDoorPoints.Length)
				{
					currentState = SceneState.InsideDialogue1;
				}
			}
			break;

		case SceneState.InsideDialogue1:
			DialogueText.text = "Son: Dad, what is this mess";
			waitTimer += Time.deltaTime;
			if (waitTimer >= WaitTime)
			{
				currentState = SceneState.InsideDialogue2;
				waitTimer = 0.0f;
			}
			break;

		case SceneState.InsideDialogue2:
			GameObject.Find ("Camera").GetComponent<Camera> ().enabled = false;
			GameObject.Find ("Camera (1)").GetComponent<Camera> ().enabled = true;
			DialogueText.text = "Dad: ...";
			waitTimer += Time.deltaTime;
			if (waitTimer >= WaitTime)
			{
				GameObject.Find ("Camera (1)").GetComponent<Camera> ().enabled = false;
				GameObject.Find ("Camera").GetComponent<Camera> ().enabled = true;
				DialogueText.text = "Son: You disgust me";
				waitTimer += Time.deltaTime;
				if (waitTimer >= WaitTime + 1.0f) {
					DialogueText.text = "Wife: You're too dirty to eat on the main table. Sit in the corner.";
					waitTimer += Time.deltaTime + 1.0f;
					if (waitTimer >= WaitTime) {
						GameObject.Find ("Camera").GetComponent<Camera> ().enabled = false;
						GameObject.Find ("Camera (1)").GetComponent<Camera> ().enabled = true;
						DialogueText.text = "Father: :(((((((((((((";
						fatherControllerRef.SetNextState ();
					}
				}
				currentState = SceneState.End;
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
		// Called when Kate reaches the door
		case SceneState.WaitForWife:
			currentState = SceneState.Dialogue1;
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
