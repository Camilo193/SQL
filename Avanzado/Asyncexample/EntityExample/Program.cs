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
            
            Console.WriteLine("--------------Begin asynchronous operation--------------");
            

            try
            {
                string encConnection = ConfigurationManager.ConnectionStrings["WideWorldImportersEntities"].ConnectionString;

                
                Console.WriteLine("Begin First Operation - Print table OrderLines asynchronous");

                PrintTableOrderLines();

                Console.WriteLine("End First Operation - Print table OrderLines asynchronous");

                //Hacemos otrra operacion    
                Console.WriteLine("Begin Second Operation - Print numbers 1 - 10 synchronous");

                PrintNumbers();

                Console.WriteLine("End Second Operation - Print numbers 1 - 10 synchronous");

                Console.WriteLine("--------------End Operation--------------");

                
                Console.ReadKey();
            }
            catch (Exception ex)
            {

                throw;
            }

        }

        public static async void PrintTableOrderLines()
        {
            string encConnection = ConfigurationManager.ConnectionStrings["WideWorldImportersEntities"].ConnectionString;
            OrderLinesBll orderLinesBll = new OrderLinesBll(encConnection);

            try
            {
                List<OrderLines> orderLines = await orderLinesBll.GetOrderLinesAsync();
                if (orderLines != null)
                {
                    orderLines.ForEach(o => {
                        Console.WriteLine("OrderLine " + o.OrderLineID);
                        Console.Write("OrderID >> " + o.OrderID + "  -  ");
                        Console.Write("StockItemID >> " + o.StockItemID + "  -  ");
                        Console.Write("Description >> " + o.Description + "  -  ");
                        Console.Write("UnitPrice >> " + o.UnitPrice + "  -  ");
                        Console.WriteLine("");
                    });
                }

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public static void PrintNumbers()
        {
            int i = 0;
            while ( i < 10)
            {
                Console.WriteLine("Number " + i);
                i++;
            }
        }
    }
}
