using UnityEngine;


public class BezierTest : MonoBehaviour
{
	public Transform p0;
	public Transform p1;
	public Transform p2;
	public Transform p3;
	
	// 分段数
	public int segments = 20;
	public float gizmoSize = 0.1f;
	// 曲线颜色
	public Color curveColor = Color.green;
	// 控制点颜色
	public Color controlPointColor = Color.yellow;
	
	/// <summary>
	/// 三次贝塞尔曲线
	/// </summary>
	/// <param name="p0">控制点0</param>
	/// <param name="p1">控制点1</param>
	/// <param name="p2">控制点2</param>
	/// <param name="p3">控制点3</param>
	/// <param name="t">插值位置</param>
	/// <returns></returns>
	public static Vector3 CubicBezier(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t)
	{
		float omt = 1f - t;
		float omt2 = omt * omt;
		float t2 = t * t;
		return p0 *(omt*omt2)+
		       p1 * (3f * omt2 * t) +
		       p2 * (3f * omt * t2) +
		       p3 * (t * t2);
	}
	
	private void OnDrawGizmos()
	{
		if(p0 == null || p1 == null || p2 == null || p3 == null)
		{
			return;
		}

		Gizmos.color = controlPointColor;
		Gizmos.DrawSphere(p0.position, gizmoSize);
		Gizmos.DrawSphere(p1.position, gizmoSize);
		Gizmos.DrawSphere(p2.position, gizmoSize);
		Gizmos.DrawSphere(p3.position, gizmoSize);
		
		Gizmos.color = Color.gray;
		Gizmos.DrawLine(p0.position, p1.position);
		Gizmos.DrawLine(p1.position, p2.position);
		Gizmos.DrawLine(p2.position, p3.position);
		
		Gizmos.color = curveColor;
		Vector3 previousPoint = p0.position;
		for (int i = 1; i <= segments; i++)
		{
			float t = i / (float)segments;
			Vector3 currentPoint = CubicBezier(p0.position, p1.position, p2.position, p3.position, t);
			Gizmos.DrawLine(previousPoint, currentPoint);
			previousPoint = currentPoint;
		}
	}
}