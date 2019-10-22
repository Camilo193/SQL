using System;
using System.Security.Principal;

namespace ActiveDirectory
{
    class Program
    {
        public static class UserIdentity

        {
            public static string GetUser()
            {
                IntPtr accountToken = WindowsIdentity.GetCurrent().Token;
                WindowsIdentity windowsIdentity = new WindowsIdentity(accountToken);
                return windowsIdentity.Name;
            }
        }

        static void Main(string[] args)
        {
            string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            Console.WriteLine(userName); 

        }
    }
}
