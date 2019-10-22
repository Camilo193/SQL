using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using EntityExample.BLL;
using EntityExample.Model;

namespace EntityExample
{
    class Program
    {
        static void Main(string[] args)
        {
            
            Console.WriteLine("Entity Framework");
            

            try
            {
                string encConnection = ConfigurationManager.ConnectionStrings["WideWorldImportersEntities"].ConnectionString;

                OrderLinesBll orderLinesBll = new OrderLinesBll(encConnection);

                OrderLines orderLines = orderLinesBll.GetOrderLinesById(231411);
                Console.WriteLine("OrderLine 31411");
                Console.Write("OrderLineID >> " + orderLines.OrderLineID + "  -  ");
                Console.Write("Description >> " + orderLines.Description + "  -  ");
                Console.Write("UnitPrice >> " + orderLines.UnitPrice + "  -  ");

                Console.WriteLine("---------------------------------------------");

                //actualizamos
                orderLines.Description = "Esta es una nueva Descripcion";
                orderLines.UnitPrice = 140;

                OrderLines orderLinesUpd = orderLinesBll.UpdateOrderLines(orderLines);

                Console.WriteLine("OrderLine 31411 Despues de la actualizacion");
                Console.Write("OrderLineID >> " + orderLines.OrderLineID + "  -  ");
                Console.Write("Description >> " + orderLines.Description + "  -  ");
                Console.Write("UnitPrice >> " + orderLines.UnitPrice + "  -  ");
                

                Console.ReadKey();
            }
            catch (Exception ex)
            {

                throw;
            }

        }
    }
}
