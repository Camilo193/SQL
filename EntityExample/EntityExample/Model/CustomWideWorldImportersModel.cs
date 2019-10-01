using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityExample.Model
{
    public partial class WideWorldImportersEntities
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="connectionString"></param>
        public WideWorldImportersEntities(string connectionString)
            : base(connectionString)
        {

        }
    }
}
