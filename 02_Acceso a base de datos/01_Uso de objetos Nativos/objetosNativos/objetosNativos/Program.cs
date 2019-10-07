using System;
using System.Data;
using System.Data.SqlClient;

namespace objetosNativos
{
    class Program
    {
        static void Main(string[] args)
        {
            string cs = "Data Source=DESKTOP-O3RV5AC;Initial Catalog=WideWorldImporters; Integrated Security = True";
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    //Abrimos la conexión con SQL
                    con.Open();
                    //Creamos un dataAdaptar y como parametro le pasamos una sentencia SQL y el objeto de conexión
                    SqlDataAdapter da = new SqlDataAdapter("EXECUTE dbo.GetTransaction", con);
                    //Creamos un DataSet
                    DataSet ds = new DataSet();
                    //El método Fill guarda los datos de la sentencia SQL en el DataSet
                    da.Fill(ds, "Clientes"); // , "Clientes" es opcional, da.fill(ds); es posible.


                    con.Close();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }
    }
}
