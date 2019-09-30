using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntityExample.Model;


namespace EntityExample.BLL
{
    public class OrderLinesBll 
    {
        private WideWorldImportersEntities _DbModelEntities;
        private string _connectionString;
        public OrderLinesBll(string @connectionString)
        {
            try
            {
                _DbModelEntities = new WideWorldImportersEntities(@connectionString);
                _connectionString = @connectionString;
            }
            catch (Exception err)
            {
                Console.Out.WriteLine(err);
            }
        }

        /// <summary>
        /// Obtenemos el lsitado de todos los registros de la tabla OrderLines
        /// </summary>
        /// <returns></returns>
        public List<OrderLines> GetOrdersLines()
        {
            List<OrderLines> ordersLines = new List<OrderLines>();

            ordersLines = _DbModelEntities.OrderLines.ToList();

            return ordersLines;
        }

        /// <summary>
        /// Obtenemos un registro por su ID de la tabla OrderLines
        /// </summary>
        /// <param name="OrderLineID"></param>
        /// <returns></returns>
        public OrderLines GetOrderLinesById(int orderLineID)
        {
            OrderLines orderLines = new OrderLines();

            orderLines = _DbModelEntities.OrderLines.FirstOrDefault(p => p.OrderLineID.Equals(orderLineID));

            return orderLines;
        }

        public OrderLines UpdateOrderLines(OrderLines orderLines)
        {
            if(orderLines!=null)
            {
                OrderLines orderLinesUpd = _DbModelEntities.OrderLines.FirstOrDefault(p => p.OrderLineID.Equals(orderLines.OrderLineID));
                if(orderLinesUpd!=null)
                {
                    orderLinesUpd.Description = orderLines.Description;
                    orderLinesUpd.PackageTypeID = orderLines.PackageTypeID;
                    orderLinesUpd.Quantity = orderLines.Quantity;
                    orderLinesUpd.UnitPrice = orderLines.UnitPrice;
                    orderLinesUpd.TaxRate = orderLines.TaxRate;
                    orderLinesUpd.PickedQuantity = orderLines.PickedQuantity;
                }
                else
                {
                    return null;
                }

                _DbModelEntities.SaveChanges();

                return orderLinesUpd;
            }

            return null;
        }


        public async Task<List<OrderLines>> GetOrderLinesAsync()
        {
            List<OrderLines> ordersLines = null;
            string SqlQuery = "EXEC Sales.SP_GetOrderLines";
            try
            {
                using (_DbModelEntities = new WideWorldImportersEntities(_connectionString))
                {
                    using (var objectContext = ((IObjectContextAdapter)_DbModelEntities).ObjectContext)
                    {
                        var objectResult = await objectContext.ExecuteStoreQueryAsync<OrderLines>(SqlQuery);
                        ordersLines = objectResult.Take(10).ToList() ;
                    }

                }
                return ordersLines;
            }
            catch (Exception ex)
            {

                throw;
            }
        }


    }
}
