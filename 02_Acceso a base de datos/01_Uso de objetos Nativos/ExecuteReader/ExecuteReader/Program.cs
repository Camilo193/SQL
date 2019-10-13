using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ExecuteReader
{
    class Program
    {
        private static void ExecuteReader(string queryString, string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(queryString, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    try
                    {
                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Console.WriteLine(String.Format("{0}", reader[0]));
                            }
                        }

                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
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
            ExecuteReader("dbo.GetTransaction", cnn);

        }
    }
}