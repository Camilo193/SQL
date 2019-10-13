using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ExecuteScalar
{
    class Program
    {
        //Este método inserta un valor y devuelve el id del último elemento insertado
        static public int AddPaymentMethod(string paymentMethodName, string connString)
        {
            Int32 newProdID = 0;
            string sql =
                "INSERT INTO Application.PaymentMethods (paymentMethodName, LastEditedBy) VALUES (@Name, @LastEditedBy); " 
                + "SELECT MAX(paymentMethodID) FROM Application.PaymentMethods;";
            using (SqlConnection connection = new SqlConnection(connString))
            {
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.Add("@Name", SqlDbType.VarChar);
                    command.Parameters.Add("@LastEditedBy", SqlDbType.Int);

                    command.Parameters["@Name"].Value = paymentMethodName;
                    command.Parameters["@LastEditedBy"].Value = 2;

                    try
                    {
                        connection.Open();
                        newProdID = (Int32)command.ExecuteScalar();
                        Console.WriteLine("The last ID inserted value is:" + newProdID.ToString());
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
                    return (int)newProdID;
                }

            }

        }
     
        static void Main(string[] args)
        {
            var cnn = ConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            AddPaymentMethod("Redeban", cnn);
        }
    }
}
