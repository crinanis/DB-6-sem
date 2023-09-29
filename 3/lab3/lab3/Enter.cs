using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void Enter()
    {
        SqlConnection conn = new SqlConnection("Context Connection=true");
        conn.Open();
        SqlCommand sqlCmd = conn.CreateCommand();

        sqlCmd.CommandText = @"exec intersection";

        SqlContext.Pipe.ExecuteAndSend(sqlCmd);
        conn.Close();
    }
}
