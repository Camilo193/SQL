using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data;
using System.Data.SqlClient;

namespace CapaEnlaceDatos
{
    public class clsManejador
    {
        public SqlConnection conexion = new SqlConnection(@"Server=RGOMEZM\SQL2017ENT;DataBase=Mitigacion;Integrated Security=SSPI");

        public void Conectar() {
            if (conexion.State == ConnectionState.Closed)
                conexion.Open();
        }

        public void Desconectar() {
            if (conexion.State == ConnectionState.Open)
                conexion.Close();
        }

        public DataTable Listado(String NombreSP,List<clsParametro> lst) {
            DataTable dt = new DataTable();
            SqlDataAdapter da;
            try
            {
                Conectar();
                da = new SqlDataAdapter(NombreSP,conexion);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                //Vrificamos if la lista no esta Vacia
                if (lst != null) { 
                //Recorremos la lista Genérica
                    for (int i = 0; i < lst.Count; i++)
                    {
                        //Pasamos cada uno de los parámetros
                        da.SelectCommand.Parameters.AddWithValue(lst[i].m_Nombre,lst[i].m_Valor);
                    }
                }
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            Desconectar();
            return dt;
        }

        public void EjecutarSP(String NombreSP,ref List<clsParametro> lst){
            SqlCommand cmd;
           try
            {
                Conectar();
                cmd = new SqlCommand(NombreSP,conexion);
                cmd.CommandType = CommandType.StoredProcedure;
                //Verificar si la lista Genérica no está vacia
                if (lst != null) { 
                //Recorremos la lista
                    for (int i = 0; i < lst.Count; i++)
                    {
                        //Verificamos si los parametros son de entrada
                        if (lst[i].m_Direccion == ParameterDirection.Input)
                            cmd.Parameters.AddWithValue(lst[i].m_Nombre,lst[i].m_Valor);
                        //Verificamos si los parametros son de salida
                        if (lst[i].m_Direccion == ParameterDirection.Output)
                            cmd.Parameters.Add(lst[i].m_Nombre, lst[i].m_TipoDato, lst[i].m_Tamaño).Direction = ParameterDirection.Output;
                    }
                    cmd.ExecuteNonQuery();
                    //Recuperamos los datos de Salida
                    for (int i = 0; i < lst.Count; i++)
                    {
                        if (cmd.Parameters[i].Direction == ParameterDirection.Output)
                            lst[i].m_Valor = cmd.Parameters[i].Value;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
