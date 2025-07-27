using System;
using UnityEngine;

public class GrassBlade : MonoBehaviour
{
	public Material material;

	private void Start()
	{
		var grassMesh = GrassMesh.CreateHighLODMesh();
		var meshFilter = gameObject.AddComponent<MeshFilter>();
		meshFilter.mesh = grassMesh;
		var meshRenderer = gameObject.AddComponent<MeshRenderer>();
		meshRenderer.sharedMaterial = material;
	}
}