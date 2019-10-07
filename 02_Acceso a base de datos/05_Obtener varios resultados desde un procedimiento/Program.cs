using System;
using System.Data;
using System.Data.SqlClient;
namespace TableValueParameter
{
    class Program
    {
        static void Main(string[] args)
        {
            try


            {
                string cs = "Data Source=DESKTOP-O3RV5AC;Initial Catalog=WideWorldImporters; Integrated Security = True";
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    //Este procedimiento almacenado solo tiene un SELECT
                    SqlCommand cmd = new SqlCommand("getOrder", con); //Leemos el procedimiento almacenado
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader rdr = cmd.ExecuteReader(); //Declaramos un dataReader
                    Console.WriteLine("Tenemos los datos seleccionados de la consulta que esta dentro del procedimiento");
                    while (rdr.Read())
                        //Seleciono que datos quiero leer del procedimiento
                    Console.WriteLine("{0} {1}", rdr["StockItemTransactionID"], rdr["Quantity"]);
                    rdr.Close();
                    //Ahora vamos a leer un procedimiento almacenado con dos SELECT
                    SqlCommand cmd2 = new SqlCommand("getItemHoldings", con);
                    cmd2.CommandType = CommandType.StoredProcedure;
                    SqlDataReader rdr2 = cmd2.ExecuteReader();
                    Console.WriteLine("Tenemos los datos de la primera consulta del procedimiento");
                    while (rdr2.Read())
                        //Seleciono que datos quiero leer
                        Console.WriteLine("{0} {1} {2}", rdr2["StockItemTransactionID"], rdr2["Quantity"], rdr2["StockItemID"]);
                    //Si ejecutamos la linea de abajo, tendremos un error porque los datos corresponden a otra consulta
                    //Console.WriteLine("{0} {1}", rdr2["StockItemID"], rdr2["QuantityOnHand"]); 

                    rdr2.NextResult(); //NextResult para ir a la siguiente consulta del Procedimiento almacenado
                    Console.WriteLine("Tenemos los datos de la segunda consulta del procedimiento");
                    while (rdr2.Read())
                        //Ahora si podemos leer datos de la otra tabla.
                        Console.WriteLine("{0} {1}", rdr2["StockItemID"], rdr2["QuantityOnHand"]);
                    rdr2.Close();
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
