using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data.Common;

namespace SqlTransactions
{
    class Program
    {
        private static void ExecuteSqlTransaction(string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                SqlCommand command = connection.CreateCommand();
                SqlTransaction transaction;

                // Comenzamos la transacción local.
                transaction = connection.BeginTransaction("SampleTransaction");

                // Debe asignar tanto el objeto de transacción como la conexión
                // al objeto de comando para una transacción local
                command.Connection = connection;
                command.Transaction = transaction;

                try
                {
                    command.CommandText =
                        "INSERT INTO Application.PaymentMethods (PaymentMethodName ,LastEditedBy) VALUES ('CMCBIMO' ,2)";

                    command.ExecuteNonQuery();
                    command.CommandText =
                        "INSERT INTO Application.PaymentMethods (PaymentMethodName ,LastEditedBy) VALUES ('EAC' ,2)";
                    command.ExecuteNonQuery();

                    // Intentamos hacerle un COMMIT a la transaccion
                    transaction.Commit();
                    Console.WriteLine("Both records are written to database.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Commit Exception Type: {0}", ex.GetType());
                    Console.WriteLine("  Message: {0}", ex.Message);

                    // Intentamos revertir la transaccion
                    try
                    {
                        transaction.Rollback();
                    }
                    catch (Exception ex2)
                    {
                        // Este bloque manejará cualquier error que ocurra
                        // en el servidor que podría provocar un ROLLBACK
                        Console.WriteLine("Rollback Exception Type: {0}", ex2.GetType());
                        Console.WriteLine("  Message: {0}", ex2.Message);
                    }
                }
            }
        }
        static void Main(string[] args)
        {
            var cnn = ConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            //Si ejecutamos dos veces este método, fallará
            //Por violación de la clave primaria
            ExecuteSqlTransaction(cnn);
        }
    }
}
