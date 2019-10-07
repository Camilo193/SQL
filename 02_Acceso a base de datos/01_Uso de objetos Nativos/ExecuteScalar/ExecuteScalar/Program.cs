using System;
using System.Data;
using System.Data.SqlClient;

namespace ExecuteScalar
{
    class Program
    {
        static public int PaymentMethod(string paymentMethodName,  string connString)
        {
            Int32 newProdID = 0;
            string sql =
                "INSERT INTO Application.PaymentMethods (paymentMethodName, LastEditedBy) VALUES (@Name, @LastEditedBy); ";
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);

                
                cmd.Parameters.Add("@Name", SqlDbType.NVarChar);
                cmd.Parameters.Add("@LastEditedBy", SqlDbType.Int);
        
                cmd.Parameters["@Name"].Value = paymentMethodName;
                cmd.Parameters["@LastEditedBy"].Value = 2;

                try
                {
                    conn.Open();
                    newProdID = (Int32)cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
            return (int)newProdID;
        }
        static void Main(string[] args)
        {
            string cs = "Data Source=DESKTOP-O3RV5AC;Initial Catalog=WideWorldImporters; Integrated Security = True";
            PaymentMethod("Redebans", cs);
        }
    }
}
