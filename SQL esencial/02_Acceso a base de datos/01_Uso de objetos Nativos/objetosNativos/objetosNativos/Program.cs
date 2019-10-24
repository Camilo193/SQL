using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace objetosNativos
{
    class Program
    {
        public static void SqlAdapter(string queryString, string connectionString)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(queryString, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    try
                    {
                        //abrimos la conexión
                        connection.Open();
                        //Creamos un dataAdaptar y como parametro le pasamos una sentencia SQL y el objeto de conexión
                        SqlDataAdapter da = new SqlDataAdapter(queryString, connection);
                        //Creamos un DataSet
                        DataSet ds = new DataSet();
                        //El método Fill guarda los datos de la sentencia SQL en el DataSet
                        da.Fill(ds, "Clientes"); // , "Clientes" es opcional, da.fill(ds); es posible.
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
            SqlAdapter("dbo.GetTransaction", cnn);

        }
    }
}
