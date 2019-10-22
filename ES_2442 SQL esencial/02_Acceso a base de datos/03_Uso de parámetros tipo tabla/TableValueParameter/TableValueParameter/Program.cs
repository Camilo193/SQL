using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace TableValueParameter
{
    class Program
    {
        public static void tableValueParameter(string queryString, string connectionString)
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

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(queryString, connection))
                {
                    try
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Connection.Open();
                        SqlDataReader rdr = command.ExecuteReader();

                        while (rdr.Read())
                            Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}",
                                rdr["StockItemTransactionID"], rdr["StockItemID"], rdr["TransactionTypeID"], rdr["CustomerID"],
                                rdr["InvoiceID"], rdr["SupplierID"], rdr["PurchaseOrderID"], rdr["TransactionOccurredWhen"],
                                rdr["Quantity"], rdr["LastEditedBy"], rdr["LastEditedWhen"]);
                        rdr.Close();
                        // Insertamos
                        dt.Rows.Add(new object[] { 2900013, 222, 10, null, null, null, null, DateTime.Now, 12, 2, DateTime.Now });

                        // Creamos un parametro
                        SqlParameter tvpParam = new SqlParameter();
                        tvpParam.ParameterName = "@TVP";
                        tvpParam.Value = dt;
                        tvpParam.SqlDbType = SqlDbType.Structured;

                        tvpParam.TypeName = "TVPStockItemTransactions";
                        SqlCommand tvpcmd = new SqlCommand("TVPProcedure", connection);
                        tvpcmd.CommandType = CommandType.StoredProcedure;
                        tvpcmd.Parameters.Add(tvpParam);
                        tvpcmd.ExecuteNonQuery();

                        rdr = command.ExecuteReader();
                        //Lleemos los datos en la consola
                        while (rdr.Read())
                            Console.WriteLine("{0} {1} {2} {3} {4} {5} {6} {7} {8} {9} {10}",
                                rdr["StockItemTransactionID"], rdr["StockItemID"], rdr["TransactionTypeID"], rdr["CustomerID"],
                                rdr["InvoiceID"], rdr["SupplierID"], rdr["PurchaseOrderID"], rdr["TransactionOccurredWhen"],
                                rdr["Quantity"], rdr["LastEditedBy"], rdr["LastEditedWhen"]);

                        rdr.Close();
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
            tableValueParameter("dbo.GetTransaction", cnn);
        }
    }
}
