using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using CapaLogicaNegocio;

namespace CapaPresentacion
{
    public partial class Form1 : Form
    {
        private clsAlumno Alu = new clsAlumno();

        public Form1()
        {
            InitializeComponent();
        }

        private void btnRegistrar_Click(object sender, EventArgs e)
        {
            try
            {
                Alu.m_Dni = txtDni.Text;
                Alu.m_Apellidos = txtApellidos.Text;
                Alu.m_Nombres = txtNombre.Text;
                Alu.m_Sexo = rbnMasculino.Checked == true ? 'M' : 'F';
                Alu.m_FechaNac = Convert.ToDateTime(dateTimePicker1.Value);
                Alu.m_Direccion = txtDireccion.Text;
                MessageBox.Show(Alu.RegistrarAlumnos(), "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                Limpiar();

            }
            catch (Exception ex)
            {                
                MessageBox.Show(ex.Message);
            }
            
        }

        private void Limpiar() {

            txtDni.Clear();
            txtApellidos.Clear();
            txtNombre.Clear();
            rbnMasculino.Checked = true;
            dateTimePicker1.Value = DateTime.Now;
            txtDireccion.Clear();
            txtDni.Focus();
        }

        private void btnActualizar_Click(object sender, EventArgs e)
        {
            try
            {
            Alu.m_Dni = txtDni.Text;
            Alu.m_Apellidos = txtApellidos.Text;
            Alu.m_Nombres = txtNombre.Text;
            Alu.m_Sexo = rbnMasculino.Checked == true ? 'M' : 'F';
            Alu.m_FechaNac = Convert.ToDateTime(dateTimePicker1.Value);
            Alu.m_Direccion = txtDireccion.Text;
            MessageBox.Show(Alu.ActualizarDatos(),"Aviso",MessageBoxButtons.OK,MessageBoxIcon.Information);
            Limpiar();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
            Alu.m_Dni = txtDni.Text;
            MessageBox.Show(Alu.EliminarRegistro(),"Aviso",MessageBoxButtons.OK,MessageBoxIcon.Information);
            Limpiar();
            }
            catch (Exception ex)
            {                
                MessageBox.Show(ex.Message);
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {

            try
            {
            DataTable dt = new DataTable();
            DataRow row;
            Alu.m_Dni = txtDni.Text;
            dt = Alu.BuscarAlumno(Alu.m_Dni);
            if (dt.Rows.Count == 1)
            {
                row = dt.Rows[0];
                txtApellidos.Text = row[2].ToString();
                txtNombre.Text = row[3].ToString();
                if (row[4].ToString() == "M")
                    rbnMasculino.Checked = true;
                else
                    rbnFemenino.Checked = true;
                dateTimePicker1.Value = Convert.ToDateTime(row[5].ToString());
                txtDireccion.Text = row[6].ToString();
                MessageBox.Show("Registro Encontrado Ok...!!!","Aviso",MessageBoxButtons.OK,MessageBoxIcon.Information);
            }
            else {
                MessageBox.Show("Registro de Alumno no Existe","Error",MessageBoxButtons.OK,MessageBoxIcon.Error);
                Limpiar();
            }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            FrmListadoAlumnos fr = new FrmListadoAlumnos();
            fr.ShowDialog();
        }
    }
}
