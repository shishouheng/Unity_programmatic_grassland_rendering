using UnityEngine;

public class GrassMesh
{
    // 高模草叶15个顶点
    public static Mesh CreateHighLODMesh()
    {
        Mesh mesh = new Mesh();
        
        // 设置单个草叶的顶点坐标---yz平面上
        mesh.vertices = new Vector3[]
        {
            new Vector3(0.000000f, 0.15599f, 0.03445f),
            new Vector3(0.000000f, 0.000000f, -0.03444f),
            new Vector3(0.000000f, 0.000000f, 0.03444f),
            new Vector3(0.000000f, 0.15599f, -0.03445f),
            new Vector3(0.000000f, 0.27249f, -0.03193f),
            new Vector3(0.000000f, 0.27249f, 0.03193f),
            new Vector3(0.000000f, 0.38111f, -0.02942f),
            new Vector3(0.000000f, 0.38111f, 0.02942f),
            new Vector3(0.000000f, 0.47325f, -0.02620f),
            new Vector3(0.000000f, 0.47325f, 0.02620f),
            new Vector3(0.000000f, 0.55531f, -0.02338f),
            new Vector3(0.000000f, 0.55531f, 0.02338f),
            new Vector3(0.000000f, 0.63064f, -0.01728f),
            new Vector3(0.000000f, 0.63064f, 0.01728f),
            new Vector3(0.000000f, 0.70819f, 0.00000f)
        };
        
        // 三角形索引数据
        mesh.triangles = new int[]
        { 
            0, 1, 2,
            0, 3, 1,
            0, 4, 3,
            0, 5, 4,
            5, 6, 4,
            5, 7, 6,
            7, 8, 6,
            7, 9, 8,
            9, 10, 8,
            9, 11, 10,
            12, 10, 11,
            11, 13, 12,
            13, 14, 12
        };
        
        // 顶点颜色数据
        mesh.colors = new Color[]
        {
            new Color(0.141177f, 0.000000f, 0.000000f, 1.000000f),
            new Color(0.000000f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.000000f, 0.000000f, 0.000000f, 1.000000f),
            new Color(0.141177f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.286275f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.286275f, 0.000000f, 0.000000f, 1.000000f),
            new Color(0.427451f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.427451f, 0.000000f, 0.000000f, 1.000000f),
            new Color(0.572549f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.572549f, 0.000000f, 0.000000f, 1.000000f),
            new Color(0.713726f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.713726f, 0.000000f, 0.000000f, 1.000000f),
            new Color(0.858824f, 1.000000f, 0.000000f, 1.000000f),
            new Color(0.858824f, 0.000000f, 0.000000f, 1.000000f),
            new Color(1.000000f, 0.498039f, 0.000000f, 1.000000f)
        };
        
        // uv坐标数据
        mesh.uv = new Vector2[]
        {
            new Vector2(0.450011f, 0.220262f),
            new Vector2(0.550490f, 0.000000f),
            new Vector2(0.450038f, 0.000000f),
            new Vector2(0.550516f, 0.220262f),
            new Vector2(0.546832f, 0.384773f),
            new Vector2(0.453695f, 0.384773f),
            new Vector2(0.543177f, 0.538140f),
            new Vector2(0.457350f, 0.538140f),
            new Vector2(0.538472f, 0.668258f),
            new Vector2(0.462055f, 0.668258f),
            new Vector2(0.534360f, 0.784132f),
            new Vector2(0.466167f, 0.784132f),
            new Vector2(0.525474f, 0.890497f),
            new Vector2(0.475053f, 0.890497f),
            new Vector2(0.500264f, 1.000000f)
        };
        
        // 重新计算包围盒、法线、切线
        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        mesh.RecalculateTangents();
        return mesh;
    }
}
