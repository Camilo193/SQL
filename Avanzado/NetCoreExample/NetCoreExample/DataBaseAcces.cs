using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace NetCoreExample
{
    public class DataBaseAcces
    {
        private string _connectionString;

        public DataBaseAcces(string connectionString)
        {
            _connectionString = connectionString;
        }

        public void ReadGetTransaction()
        {
            try
            {

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

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("EXECUTE dbo.GetTransaction", conn);
                    SqlDataReader rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                        Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}",
                            rdr["StockItemTransactionID"], rdr["StockItemID"], rdr["TransactionTypeID"], rdr["CustomerID"],
                            rdr["InvoiceID"], rdr["SupplierID"], rdr["PurchaseOrderID"], rdr["TransactionOccurredWhen"],
                            rdr["Quantity"], rdr["LastEditedBy"], rdr["LastEditedWhen"]);

                    rdr.Close();

                    Console.WriteLine("---------------------------------------------------------------------------------------------------------");
                    Console.WriteLine("---------------------------------------------------------------------------------------------------------");

                    // Insertar algunas filas.
                    dt.Rows.Add(new object[] { 29123470, 222, 10, null, null, null, null, DateTime.Now, 12, 2, DateTime.Now });
                    // Creamos el parametro
                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@TVP";
                    tvpParam.Value = dt;
                    tvpParam.SqlDbType = SqlDbType.Structured;

                    tvpParam.TypeName = "TVPStockItemTransactions";
                    SqlCommand tvpcmd = new SqlCommand("TVPProcedure", conn);
                    tvpcmd.CommandType = CommandType.StoredProcedure;
                    tvpcmd.Parameters.Add(tvpParam);
                    tvpcmd.ExecuteNonQuery();

                    rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                        Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}",
                            rdr["StockItemTransactionID"], rdr["StockItemID"], rdr["TransactionTypeID"], rdr["CustomerID"],
                            rdr["InvoiceID"], rdr["SupplierID"], rdr["PurchaseOrderID"], rdr["TransactionOccurredWhen"],
                            rdr["Quantity"], rdr["LastEditedBy"], rdr["LastEditedWhen"]);

                    rdr.Close();
                    conn.Close();
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                throw;
            }
        }
    }
}
