using System;
using System.IO;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.FileExtensions;
using Microsoft.Extensions.Configuration.Json;

namespace NetCoreExample
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Acces to database from .NET CORE!");

            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json");

            IConfiguration config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", true, true)
                .Build();


            string ConnectionString = config.GetConnectionString("DefaultConnection");

            DataBaseAcces dataBaseAcces = new DataBaseAcces(ConnectionString);
            dataBaseAcces.ReadGetTransaction();

            Console.ReadKey();
        }
    }
}
