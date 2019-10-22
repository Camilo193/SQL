using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.Reflection;

namespace MEF
{
    class Program
    {
        [ImportMany]
        public IPerson[] Persons { get; set; }

        static void Main(string[] args)
        {
            Program p = new Program();
            p.ListAllPersons();
        }

        private void ListAllPersons()
        {
            CreateCompositionContainer();
            foreach (var person in Persons)
            {
                person.WriteMessage();
            }
        }

        private void CreateCompositionContainer()
        {
            AssemblyCatalog catalog = new AssemblyCatalog(Assembly.GetExecutingAssembly());
            CompositionContainer compositionContainer = new CompositionContainer(catalog);
            compositionContainer.ComposeParts(this);
        }
    }
}
