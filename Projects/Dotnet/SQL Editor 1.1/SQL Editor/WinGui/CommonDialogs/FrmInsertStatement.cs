
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace SQLEditor
{
	/// <summary>
	/// Summary description for FrmInsertStatement.
	/// </summary>
	public class FrmInsertStatement : System.Windows.Forms.Form
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public FrmInsertStatement()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.SuspendLayout();
            // 
            // FrmInsertStatement
            // 
            this.ClientSize = new System.Drawing.Size(292, 273);
            this.Name = "FrmInsertStatement";
            this.Text = "FrmInsertStatement";
            this.ResumeLayout(false);

		}
		#endregion
	}
}
