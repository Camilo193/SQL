using System;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace InOut
{
    class Program
    {
        private static void printInOut(string queryString, string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(queryString, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    try
                    {

                        int OrderId = 1;
                        command.Parameters.AddWithValue("@OrderID", OrderId);

                        SqlParameter outputParameter = new SqlParameter();
                        outputParameter.ParameterName = "@CustomerID";
                        outputParameter.SqlDbType = System.Data.SqlDbType.Int;
                        outputParameter.Direction = System.Data.ParameterDirection.Output;
                        command.Parameters.Add(outputParameter);
                        
                        //Abrimos la conexión
                        command.Connection.Open();
                        command.ExecuteNonQuery();
                        string CustomerID = outputParameter.Value.ToString();
                        Console.WriteLine("Output: " + CustomerID);

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
            printInOut("dbo.GetCustomer", cnn);


        }
    }
}
