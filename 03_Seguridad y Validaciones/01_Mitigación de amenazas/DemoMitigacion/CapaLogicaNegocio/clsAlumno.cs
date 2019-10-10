using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using CapaEnlaceDatos;

namespace CapaLogicaNegocio
{
    public class clsAlumno
    {
        private clsManejador M = new clsManejador();

        //Atributos
        public String m_Dni {get;set;}
        public String m_Apellidos { get; set; }
        public String m_Nombres { get; set; }
        public Char m_Sexo { get; set; }
        public DateTime m_FechaNac { get; set; }
        public String m_Direccion { get; set; }


        public DataTable Listado() {
            return M.Listado("ListarALumnos",null);
        }


        public String RegistrarAlumnos() {
            List<clsParametro> lst = new List<clsParametro>();
            String Mensaje = "";
            try
            {
                //Pasamos los parametros de entrada
                lst.Add(new clsParametro("@Dni",m_Dni));
                lst.Add(new clsParametro("@Apellidos",m_Apellidos));
                lst.Add(new clsParametro("@Nombres",m_Nombres));
                lst.Add(new clsParametro("@Sexo",m_Sexo));
                lst.Add(new clsParametro("@FechaNac",m_FechaNac));
                lst.Add(new clsParametro("@Direccion",m_Direccion));
                //Pasamos los datos de Salida
                lst.Add(new clsParametro("@Mensaje",SqlDbType.VarChar,100));
                M.EjecutarSP("RegistrarAlumnos",ref lst);
                Mensaje=lst[6].m_Valor.ToString();
            }
            catch (Exception ex)
            {                
                throw ex;
            }
            return Mensaje;
        }

        public String ActualizarDatos() {
            List<clsParametro> lst = new List<clsParametro>();
            String Mensaje = "";
            try
            {
                lst.Add(new clsParametro("@Dni",m_Dni));
                lst.Add(new clsParametro("@Apellidos",m_Apellidos));
                lst.Add(new clsParametro("@Nombres",m_Nombres));
                lst.Add(new clsParametro("@Sexo",m_Sexo));
                lst.Add(new clsParametro("@FechaNac",m_FechaNac));
                lst.Add(new clsParametro("@Direccion",m_Direccion));
                lst.Add(new clsParametro("@Mensaje",SqlDbType.VarChar,100));
                M.EjecutarSP("ActualizarDatos",ref lst);
                Mensaje=lst[6].m_Valor.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Mensaje;
        }

        public String EliminarRegistro() {
            List<clsParametro> lst = new List<clsParametro>();
            String Mensaje = "";
            try
            {
                lst.Add(new clsParametro("@Dni",m_Dni));
                lst.Add(new clsParametro("@Mensaje",SqlDbType.VarChar,100));
                M.EjecutarSP("EliminarAlumnos",ref lst);
                Mensaje = lst[1].m_Valor.ToString();
            }
            catch (Exception ex)
            {  
                throw ex;
            }
            return Mensaje;
        }

        public DataTable BuscarAlumno(String objDni) {
            DataTable dt = new DataTable();
            List<clsParametro> lst = new List<clsParametro>();
            try
            {
                lst.Add(new clsParametro("@Dni",objDni));
                dt = M.Listado("BuscarAlumnos",lst);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
    }
}
