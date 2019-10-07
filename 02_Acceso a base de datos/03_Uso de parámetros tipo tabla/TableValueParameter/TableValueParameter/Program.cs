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
                
                DataTable dt = new DataTable("TableToInsert");
                dt.Columns.Add("StockItemTransactionID", typeof(int));
                dt.Columns.Add("StockItemID", typeof(int));
                dt.Columns.Add("TransactionTypeID", typeof(int));
                dt.Columns.Add("CustomerID", typeof(int));
                dt.Columns.Add("InvoiceID", typeof(int));
                dt.Columns.Add("SupplierID", typeof(int));
                dt.Columns.Add("PurchaseOrderID", typeof(int));
                dt.Columns.Add("TransactionOccurredWhen", typeof(DateTime));
                dt.Columns.Add("Quantity", typeof(decimal));
                dt.Columns.Add("LastEditedBy", typeof(int));
                dt.Columns.Add("LastEditedWhen", typeof(DateTime));

                using (SqlConnection con = new SqlConnection(cs))


                {
                    
                    con.Open();
                    SqlCommand cmd = new SqlCommand("EXECUTE GetTransaction", con);
                    SqlDataReader rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                        Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}", 
                            rdr["StockItemTransactionID"], rdr["StockItemID"], rdr["TransactionTypeID"], rdr["CustomerID"], 
                            rdr["InvoiceID"], rdr["SupplierID"], rdr["PurchaseOrderID"], rdr["TransactionOccurredWhen"], 
                            rdr["Quantity"], rdr["LastEditedBy"], rdr["LastEditedWhen"]);

                    rdr.Close();
                    
                    

                    // Insertamos
                    dt.Rows.Add(new object[] {29123468, 222, 10, null, null, null, null, DateTime.Now, 12, 2, DateTime.Now});
                    // Creamos un parametro
                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@TVP";
                    tvpParam.Value = dt;
                    tvpParam.SqlDbType = SqlDbType.Structured;

                    tvpParam.TypeName = "TVPStockItemTransactions";
                    SqlCommand tvpcmd = new SqlCommand("TVPProcedure", con);
                    tvpcmd.CommandType = CommandType.StoredProcedure;
                    tvpcmd.Parameters.Add(tvpParam);
                    tvpcmd.ExecuteNonQuery();

                    rdr = cmd.ExecuteReader();
                    //Lleemos los datos en la consola
                    while (rdr.Read())
                        Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}",
                            rdr["StockItemTransactionID"], rdr["StockItemID"], rdr["TransactionTypeID"], rdr["CustomerID"],
                            rdr["InvoiceID"], rdr["SupplierID"], rdr["PurchaseOrderID"], rdr["TransactionOccurredWhen"],
                            rdr["Quantity"], rdr["LastEditedBy"], rdr["LastEditedWhen"]);

                    rdr.Close();
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
