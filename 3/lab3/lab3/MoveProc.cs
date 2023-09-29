using Microsoft.SqlServer.Server;
using System;
using System.Data.SqlTypes;
using System.IO;

public partial class StoredProcedures
{
    [SqlProcedure]
    public static void MoveProc (SqlString pathFrom, SqlString pathTo)
    {
        try
        {
            if (!pathFrom.IsNull && !pathTo.IsNull)
            {
                var dir = Path.GetDirectoryName(pathTo.Value);
                if (!Directory.Exists(dir))
                    if (dir != null)
                        Directory.CreateDirectory(dir);
                System.IO.File.Copy(Path.Combine(Path.GetDirectoryName(pathFrom.Value), Path.Combine(Path.GetFileName(pathFrom.Value))), Path.Combine(Path.GetDirectoryName(pathTo.Value), Path.Combine(Path.GetFileName(pathTo.Value))), true);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }
    }
}
