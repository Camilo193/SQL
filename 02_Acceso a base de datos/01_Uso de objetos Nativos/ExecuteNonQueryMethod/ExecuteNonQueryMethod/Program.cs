using System;
using System.Data.SqlClient;
using System.Data;

namespace ExecuteNonQueryMethod
{
    class Program
    {
        private static int CreateCommand(string queryString, string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(
                       connectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Connection.Open();
                int ra = command.ExecuteNonQuery();
                Console.WriteLine("Affected rows: " + ra);
                return ra;
            }
        }
        static void Main(string[] args)
        {
            string cs = "Data Source=DESKTOP-O3RV5AC;Initial Catalog=WideWorldImporters; Integrated Security = True";
            CreateCommand("dbo.DeleteAdviserPaymentMethods", cs);
        }
    }
}
