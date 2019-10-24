namespace CSharp_3Capas_SinPatronDeDiseño
{
    partial class frmProducto
    {
        /// <summary>
        /// Variable del diseñador requerida.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén utilizando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben eliminar; false en caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de Windows Forms

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido del método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            this.btnAgregar = new System.Windows.Forms.Button();
            this.txtId = new System.Windows.Forms.TextBox();
            this.dgvDatos = new System.Windows.Forms.DataGridView();
            this.columnId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.columnDescripcion = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.columnMarca = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.columnPrecio = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.gpoBoxCatalogo = new System.Windows.Forms.GroupBox();
            this.grpoBoxDatos = new System.Windows.Forms.GroupBox();
            this.lblPrecio = new System.Windows.Forms.Label();
            this.txtPrecio = new System.Windows.Forms.TextBox();
            this.lblMarca = new System.Windows.Forms.Label();
            this.txtMarca = new System.Windows.Forms.TextBox();
            this.lblDescripcion = new System.Windows.Forms.Label();
            this.txtDescripcion = new System.Windows.Forms.TextBox();
            this.lblId = new System.Windows.Forms.Label();
            this.btbnBuscar = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dgvDatos)).BeginInit();
            this.gpoBoxCatalogo.SuspendLayout();
            this.grpoBoxDatos.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnAgregar
            // 
            this.btnAgregar.Location = new System.Drawing.Point(575, 42);
            this.btnAgregar.Name = "btnAgregar";
            this.btnAgregar.Size = new System.Drawing.Size(93, 37);
            this.btnAgregar.TabIndex = 0;
            this.btnAgregar.Text = "&Agregar";
            this.btnAgregar.UseVisualStyleBackColor = true;
            this.btnAgregar.Click += new System.EventHandler(this.btnAgregar_Click);
            // 
            // txtId
            // 
            this.txtId.Location = new System.Drawing.Point(78, 28);
            this.txtId.Name = "txtId";
            this.txtId.Size = new System.Drawing.Size(111, 20);
            this.txtId.TabIndex = 1;
            this.txtId.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtId_KeyDown);
            // 
            // dgvDatos
            // 
            this.dgvDatos.AllowUserToAddRows = false;
            this.dgvDatos.AllowUserToDeleteRows = false;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle6.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvDatos.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvDatos.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvDatos.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.columnId,
            this.columnDescripcion,
            this.columnMarca,
            this.columnPrecio});
            this.dgvDatos.Location = new System.Drawing.Point(8, 16);
            this.dgvDatos.Name = "dgvDatos";
            this.dgvDatos.ReadOnly = true;
            this.dgvDatos.Size = new System.Drawing.Size(551, 222);
            this.dgvDatos.TabIndex = 2;
            // 
            // columnId
            // 
            this.columnId.HeaderText = "Id";
            this.columnId.Name = "columnId";
            this.columnId.ReadOnly = true;
            this.columnId.Width = 70;
            // 
            // columnDescripcion
            // 
            this.columnDescripcion.HeaderText = "Descripción";
            this.columnDescripcion.Name = "columnDescripcion";
            this.columnDescripcion.ReadOnly = true;
            this.columnDescripcion.Width = 200;
            // 
            // columnMarca
            // 
            this.columnMarca.HeaderText = "Marca";
            this.columnMarca.Name = "columnMarca";
            this.columnMarca.ReadOnly = true;
            this.columnMarca.Width = 152;
            // 
            // columnPrecio
            // 
            this.columnPrecio.HeaderText = "Precio";
            this.columnPrecio.Name = "columnPrecio";
            this.columnPrecio.ReadOnly = true;
            this.columnPrecio.Width = 85;
            // 
            // gpoBoxCatalogo
            // 
            this.gpoBoxCatalogo.Controls.Add(this.dgvDatos);
            this.gpoBoxCatalogo.Location = new System.Drawing.Point(4, 160);
            this.gpoBoxCatalogo.Name = "gpoBoxCatalogo";
            this.gpoBoxCatalogo.Size = new System.Drawing.Size(565, 246);
            this.gpoBoxCatalogo.TabIndex = 3;
            this.gpoBoxCatalogo.TabStop = false;
            this.gpoBoxCatalogo.Text = "Catalogo Productos";
            // 
            // grpoBoxDatos
            // 
            this.grpoBoxDatos.Controls.Add(this.lblPrecio);
            this.grpoBoxDatos.Controls.Add(this.txtPrecio);
            this.grpoBoxDatos.Controls.Add(this.lblMarca);
            this.grpoBoxDatos.Controls.Add(this.txtMarca);
            this.grpoBoxDatos.Controls.Add(this.lblDescripcion);
            this.grpoBoxDatos.Controls.Add(this.txtDescripcion);
            this.grpoBoxDatos.Controls.Add(this.lblId);
            this.grpoBoxDatos.Controls.Add(this.txtId);
            this.grpoBoxDatos.Location = new System.Drawing.Point(4, 12);
            this.grpoBoxDatos.Name = "grpoBoxDatos";
            this.grpoBoxDatos.Size = new System.Drawing.Size(565, 142);
            this.grpoBoxDatos.TabIndex = 4;
            this.grpoBoxDatos.TabStop = false;
            this.grpoBoxDatos.Text = "Datos del Producto";
            // 
            // lblPrecio
            // 
            this.lblPrecio.AutoSize = true;
            this.lblPrecio.Location = new System.Drawing.Point(13, 109);
            this.lblPrecio.Name = "lblPrecio";
            this.lblPrecio.Size = new System.Drawing.Size(37, 13);
            this.lblPrecio.TabIndex = 8;
            this.lblPrecio.Text = "Precio";
            // 
            // txtPrecio
            // 
            this.txtPrecio.Location = new System.Drawing.Point(78, 106);
            this.txtPrecio.Name = "txtPrecio";
            this.txtPrecio.Size = new System.Drawing.Size(111, 20);
            this.txtPrecio.TabIndex = 7;
            this.txtPrecio.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtPrecio_KeyDown);
            // 
            // lblMarca
            // 
            this.lblMarca.AutoSize = true;
            this.lblMarca.Location = new System.Drawing.Point(13, 83);
            this.lblMarca.Name = "lblMarca";
            this.lblMarca.Size = new System.Drawing.Size(37, 13);
            this.lblMarca.TabIndex = 6;
            this.lblMarca.Text = "Marca";
            // 
            // txtMarca
            // 
            this.txtMarca.Location = new System.Drawing.Point(78, 80);
            this.txtMarca.Name = "txtMarca";
            this.txtMarca.Size = new System.Drawing.Size(340, 20);
            this.txtMarca.TabIndex = 5;
            // 
            // lblDescripcion
            // 
            this.lblDescripcion.AutoSize = true;
            this.lblDescripcion.Location = new System.Drawing.Point(13, 57);
            this.lblDescripcion.Name = "lblDescripcion";
            this.lblDescripcion.Size = new System.Drawing.Size(63, 13);
            this.lblDescripcion.TabIndex = 4;
            this.lblDescripcion.Text = "Descripción";
            // 
            // txtDescripcion
            // 
            this.txtDescripcion.Location = new System.Drawing.Point(78, 54);
            this.txtDescripcion.Name = "txtDescripcion";
            this.txtDescripcion.Size = new System.Drawing.Size(340, 20);
            this.txtDescripcion.TabIndex = 3;
            // 
            // lblId
            // 
            this.lblId.AutoSize = true;
            this.lblId.Location = new System.Drawing.Point(13, 31);
            this.lblId.Name = "lblId";
            this.lblId.Size = new System.Drawing.Size(16, 13);
            this.lblId.TabIndex = 2;
            this.lblId.Text = "Id";
            // 
            // btbnBuscar
            // 
            this.btbnBuscar.Location = new System.Drawing.Point(575, 85);
            this.btbnBuscar.Name = "btbnBuscar";
            this.btbnBuscar.Size = new System.Drawing.Size(93, 37);
            this.btbnBuscar.TabIndex = 5;
            this.btbnBuscar.Text = "&Buscar";
            this.btbnBuscar.UseVisualStyleBackColor = true;
            this.btbnBuscar.Click += new System.EventHandler(this.btbnBuscar_Click);
            // 
            // frmProducto
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.ClientSize = new System.Drawing.Size(672, 409);
            this.Controls.Add(this.btbnBuscar);
            this.Controls.Add(this.grpoBoxDatos);
            this.Controls.Add(this.gpoBoxCatalogo);
            this.Controls.Add(this.btnAgregar);
            this.Name = "frmProducto";
            this.Text = "Ejemplo sin Patron 3 Capas";
            ((System.ComponentModel.ISupportInitialize)(this.dgvDatos)).EndInit();
            this.gpoBoxCatalogo.ResumeLayout(false);
            this.grpoBoxDatos.ResumeLayout(false);
            this.grpoBoxDatos.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnAgregar;
        private System.Windows.Forms.TextBox txtId;
        private System.Windows.Forms.DataGridView dgvDatos;
        private System.Windows.Forms.GroupBox gpoBoxCatalogo;
        private System.Windows.Forms.GroupBox grpoBoxDatos;
        private System.Windows.Forms.DataGridViewTextBoxColumn columnId;
        private System.Windows.Forms.DataGridViewTextBoxColumn columnDescripcion;
        private System.Windows.Forms.DataGridViewTextBoxColumn columnMarca;
        private System.Windows.Forms.DataGridViewTextBoxColumn columnPrecio;
        private System.Windows.Forms.Label lblPrecio;
        private System.Windows.Forms.TextBox txtPrecio;
        private System.Windows.Forms.Label lblMarca;
        private System.Windows.Forms.TextBox txtMarca;
        private System.Windows.Forms.Label lblDescripcion;
        private System.Windows.Forms.TextBox txtDescripcion;
        private System.Windows.Forms.Label lblId;
        private System.Windows.Forms.Button btbnBuscar;
    }
}

