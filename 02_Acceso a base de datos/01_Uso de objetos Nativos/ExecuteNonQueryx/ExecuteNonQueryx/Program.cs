using System;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ExecuteNonQueryx
{
    class Program
    {
        private static int CreateCommand(string queryString, string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(
                       connectionString))
            {
                using (SqlCommand command = new SqlCommand(queryString, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Connection.Open();
                    int affectedRows = command.ExecuteNonQuery();
                    Console.WriteLine("Affected rows: " + affectedRows.ToString());
                    return affectedRows;
                }
                   
            }
        }
        static void Main(string[] args)
        {
            var cnn = ConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            CreateCommand("dbo.DeleteAdviserPaymentMethods", cnn);
        }
    }
}

