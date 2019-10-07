using System;
using System.Data;
using System.Data.SqlClient;

namespace ExecuteReader
{
    class Program
    {
        private static void ExecuteReader(string queryString,
    string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(
                       connectionString))
            {
                connection.Open();

                SqlCommand command = new SqlCommand(queryString, connection);
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Console.WriteLine(String.Format("{0}", reader[0]));
                }
            }
        }

        static void Main(string[] args)
        {
            string cs = "Data Source=DESKTOP-O3RV5AC;Initial Catalog=WideWorldImporters; Integrated Security = True";
            ExecuteReader("EXECUTE GetTransaction", cs);
        }
    }
}
