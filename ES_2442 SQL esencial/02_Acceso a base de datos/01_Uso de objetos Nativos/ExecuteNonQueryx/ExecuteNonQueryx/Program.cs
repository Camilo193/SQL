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
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(queryString, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    try
                    {
                        command.Connection.Open();
                        int affectedRows = command.ExecuteNonQuery();
                        Console.WriteLine("Affected rows: " + affectedRows.ToString());
                        return affectedRows;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                        return -1;
                    }
                    finally
                    {
                        if (connection != null)
                        {
                            connection.Dispose();
                        }
                        if (command != null)
                        {
                            command.Dispose();
                        }
                    }

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

