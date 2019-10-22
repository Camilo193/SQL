using System;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.Reflection;


namespace MEF
{
    [Export(typeof(IPerson))]
    public class Customer : IPerson
    {
        public void WriteMessage()
        {
            Console.WriteLine("I'm Customer");
            //Console.ReadLine();
        }
    }
}
