using System;
using System.Data;
using System.Windows.Forms;
using System.Configuration;
using System.Data.SqlServerCe;

namespace CSharp_3Capas_SinPatronDeDiseño
{
    public partial class frmProducto : Form
    {
        public frmProducto()
        {
            InitializeComponent();
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            try
            {
                decimal num;
                bool isNum = Decimal.TryParse(txtPrecio.Text.Trim(), out num);
                if (!string.IsNullOrEmpty(txtDescripcion.Text) || !string.IsNullOrEmpty(txtMarca.Text) || !string.IsNullOrEmpty(txtPrecio.Text))
                {
                    if (!isNum)
                    {
                        MessageBox.Show("El Precio no tiene un formato valido", "Para continuar");
                        return;
                    }

                    using (SqlCeConnection cnx = new SqlCeConnection(ConfigurationManager.ConnectionStrings["cnxString"].ToString()))
                    {
                        cnx.Open();
                        const string sqlQuery = "INSERT INTO Producto (Descripcion, Marca, Precio) VALUES (@descripcion, @marca, @precio)";
                        using (SqlCeCommand cmd = new SqlCeCommand(sqlQuery, cnx))
                        {
                            cmd.Parameters.AddWithValue("@descripcion", txtDescripcion.Text.Trim());
                            cmd.Parameters.AddWithValue("@marca", txtMarca.Text.Trim());
                            cmd.Parameters.AddWithValue("@precio", txtPrecio.Text.Trim());

                            cmd.ExecuteNonQuery();
                        }

                        const string sqlQueryTraerTodos = "SELECT * FROM Producto ORDER BY Id ASC";
                        using (SqlCeCommand cmd2 = new SqlCeCommand(sqlQueryTraerTodos, cnx))
                        {
                            SqlCeDataAdapter da = new SqlCeDataAdapter(cmd2);
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            dgvDatos.AutoGenerateColumns = false;
                            dgvDatos.DataSource = dt;
                            dgvDatos.Columns["columnId"].DataPropertyName = "Id";
                            dgvDatos.Columns["columnDescripcion"].DataPropertyName = "Descripcion";
                            dgvDatos.Columns["columnMarca"].DataPropertyName = "Marca";
                            dgvDatos.Columns["columnPrecio"].DataPropertyName = "Precio";
                        }
                    }
                }
                else
                    MessageBox.Show("Descripción, Marca y Precio son mandatorios, por favor proporcione la información necesaria",
                                    "Para continuar");
            }
            catch (Exception ex)
            {
                MessageBox.Show(string.Format("Error: {0}", ex.Message), "Error inesperado");
            }
        }

        private void txtPrecio_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyData == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                try
                {
                    decimal num;
                    bool isNum = Decimal.TryParse(txtPrecio.Text.Trim(), out num);
                    if (!string.IsNullOrEmpty(txtDescripcion.Text) || !string.IsNullOrEmpty(txtMarca.Text) || !string.IsNullOrEmpty(txtPrecio.Text))
                    {
                        if (!isNum)
                        {
                            MessageBox.Show("El Precio no tiene un formato valido", "Para continuar");
                            return;
                        }

                        using (SqlCeConnection cnx = new SqlCeConnection(ConfigurationManager.ConnectionStrings["cnxString"].ToString()))
                        {
                            cnx.Open();
                            const string sqlQuery = "INSERT INTO Producto (Descripcion, Marca, Precio) VALUES (@descripcion, @marca, @precio)";
                            using (SqlCeCommand cmd = new SqlCeCommand(sqlQuery, cnx))
                            {
                                cmd.Parameters.AddWithValue("@descripcion", txtDescripcion.Text.Trim());
                                cmd.Parameters.AddWithValue("@marca", txtMarca.Text.Trim());
                                cmd.Parameters.AddWithValue("@precio", txtPrecio.Text.Trim());

                                cmd.ExecuteNonQuery();
                            }

                            const string sqlQueryTraerTodos = "SELECT * FROM Producto ORDER BY Id ASC";
                            using (SqlCeCommand cmd2 = new SqlCeCommand(sqlQueryTraerTodos, cnx))
                            {
                                SqlCeDataAdapter da = new SqlCeDataAdapter(cmd2);
                                DataTable dt = new DataTable();
                                da.Fill(dt);

                                dgvDatos.AutoGenerateColumns = false;
                                dgvDatos.DataSource = dt;
                                dgvDatos.Columns["columnId"].DataPropertyName = "Id";
                                dgvDatos.Columns["columnDescripcion"].DataPropertyName = "Descripcion";
                                dgvDatos.Columns["columnMarca"].DataPropertyName = "Marca";
                                dgvDatos.Columns["columnPrecio"].DataPropertyName = "Precio";
                            }
                        }
                    }
                    else
                        MessageBox.Show("Descripción, Marca y Precio son mandatorios, por favor proporcione la información necesaria",
                                        "Para continuar");
                }
                catch (Exception ex)
                {
                    MessageBox.Show(string.Format("Error: {0}", ex.Message), "Error inesperado");
                }
            }
        }

        private void btbnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                int num;
                bool isNum = int.TryParse(txtId.Text.Trim(), out num);

                if (!isNum)
                {
                    MessageBox.Show("El id proporcionado no tiene un formato valido, por favor proporcione un numero entero", "Para continuar");
                    return;
                }
                using (SqlCeConnection cnx = new SqlCeConnection(ConfigurationManager.ConnectionStrings["cnxString"].ToString()))
                {
                    const string sqlGetById = "SELECT * FROM Producto WHERE Id = @id";
                    using (SqlCeCommand cmd = new SqlCeCommand(sqlGetById, cnx))
                    {
                        cmd.Parameters.AddWithValue("@id", txtId.Text);

                        SqlCeDataAdapter da = new SqlCeDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        dgvDatos.AutoGenerateColumns = false;
                        dgvDatos.DataSource = dt;
                        dgvDatos.Columns["columnId"].DataPropertyName = "Id";
                        dgvDatos.Columns["columnDescripcion"].DataPropertyName = "Descripcion";
                        dgvDatos.Columns["columnMarca"].DataPropertyName = "Marca";
                        dgvDatos.Columns["columnPrecio"].DataPropertyName = "Precio";
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(string.Format("Error: {0}", ex.Message), "Error inesperado");
            }
        }

        private void txtId_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyData == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                try
                {
                    int num;
                    bool isNum = int.TryParse(txtId.Text.Trim(), out num);

                    if (!isNum)
                    {
                        MessageBox.Show("El id proporcionado no tiene un formato valido, por favor proporcione un numero entero", "Para continuar");
                        return;
                    }
                    using (SqlCeConnection cnx = new SqlCeConnection(ConfigurationManager.ConnectionStrings["cnxString"].ToString()))
                    {
                        const string sqlGetById = "SELECT * FROM Producto WHERE Id = @id";
                        using (SqlCeCommand cmd = new SqlCeCommand(sqlGetById, cnx))
                        {
                            cmd.Parameters.AddWithValue("@id", txtId.Text);

                            SqlCeDataAdapter da = new SqlCeDataAdapter(cmd);
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            dgvDatos.AutoGenerateColumns = false;
                            dgvDatos.DataSource = dt;
                            dgvDatos.Columns["columnId"].DataPropertyName = "Id";
                            dgvDatos.Columns["columnDescripcion"].DataPropertyName = "Descripcion";
                            dgvDatos.Columns["columnMarca"].DataPropertyName = "Marca";
                            dgvDatos.Columns["columnPrecio"].DataPropertyName = "Precio";
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(string.Format("Error: {0}", ex.Message), "Error inesperado");
                }
            }

        }
    }
}
