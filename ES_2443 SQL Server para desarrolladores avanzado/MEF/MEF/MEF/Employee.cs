using System;
using System.ComponentModel.Composition;


namespace MEF
{

    public class Employee : IPerson
    {
        [Export(typeof(IPerson))]
        public void WriteMessage()
        {
            Console.WriteLine("I'm a Employee");
            //Console.ReadLine();
        }
    }
}
