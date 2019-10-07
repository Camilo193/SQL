using System;


namespace IndexOutOfRangeException
{
    class Program
    {
        public static void test1()
        {
            int[] array = { 3, 6, 9, 12, 15, 18, 21 }; //7 elementos
            int[] newArray = new int[6]; //6 elementos 
            //Asignamos el último elemento del array al nuevo array
            newArray[array.Length - 1] = array[array.Length - 1];
        }

        public static void test2()
        {
            Array values = Array.CreateInstance(typeof(int), new int[] { 10 },
                                          new int[] { 1 });
            int value = 2;
            //Asigna los valores .
            for (int ctr = 0; ctr < values.Length; ctr++)
            {
                values.SetValue(value, ctr);
                value *= 2;
            }

            // Imprime los valores.
            for (int ctr = 0; ctr < values.Length; ctr++)
                Console.Write("{0}    ", values.GetValue(ctr));
        }

        static double safeDivision(double x, double y)
        {
            if (y == 0)
                throw new System.DivideByZeroException();
            return x / y;
        }


        static void Main(string[] args)
        {

            double a = 98, b = 0;
            double result = 0;
            try
            {
                safeDivision(a, b); //Como el primer método genera excepcion, no se ejecuta el segundo método
                Console.WriteLine("{0} divided by {1} = {2}", a, b, result);
                test1();

            }
            //Los bloques catch deben ordenarse siempre de más específico a menos específico
            catch (DivideByZeroException ex)
            {
                Console.WriteLine(ex);
            }
            catch (System.IndexOutOfRangeException ex2)
            {
                //Mostramos la excepción y el número de la linea dónde se produjo la excepción
                Console.WriteLine(ex2.Message + ex2.StackTrace);
            }




            try
            {
                test2();
            }
            catch (Exception ex)
            {
                //Mostramos la excepción y el número de la linea dónde se produjo la excepción
                Console.WriteLine(ex.Message + ex.StackTrace);
            }



        }


    }
}

