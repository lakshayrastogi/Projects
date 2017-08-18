using UnityEngine;
using System.Collections;

public class fatherController : MonoBehaviour {

	public Vector3 move;
	public float speed;

	public void SetNextState()
	{
		MoveTo (move, speed);
	}

	bool MoveTo(Vector3 targetPos, float speed)
	{
		float step = speed * Time.deltaTime;
		transform.position = Vector3.MoveTowards(transform.position, targetPos, step);

		return (transform.position == targetPos);
	}
}
