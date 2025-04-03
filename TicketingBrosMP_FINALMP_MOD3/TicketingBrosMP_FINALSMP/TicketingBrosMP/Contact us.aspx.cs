using System;
using System.Data.OleDb;
using System.Web.UI;

namespace TicketingBrosMP
{
    public partial class Contact_us : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            try
            {
                string dbPath = Server.MapPath("~/App_Data/TicketingBros.mdb");

                using (OleDbConnection connection = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + dbPath))
                {
                    connection.Open();

                   
                    string sqlcmd = "INSERT INTO Inquiry_TBL (Sender_lastname, Sender_firstname, Sender_Tel_no, Sender_Email, Sender_Comments, Sender_DateTime) " +
                                    "VALUES (@lastName, @firstName, @phone, @email, @message, @dateTime)";

                    using (OleDbCommand sqlcommand = new OleDbCommand(sqlcmd, connection))
                    {
                        sqlcommand.Parameters.AddWithValue("@lastName", lasttxb.Text.Trim());
                        sqlcommand.Parameters.AddWithValue("@firstName", nametxt.Text.Trim());
                        sqlcommand.Parameters.AddWithValue("@phone", phonetxt.Text.Trim());
                        sqlcommand.Parameters.AddWithValue("@email", emailtxt.Text.Trim());
                        sqlcommand.Parameters.AddWithValue("@message", commtxt.Text.Trim());
                        sqlcommand.Parameters.AddWithValue("@dateTime", DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss")); 

                        sqlcommand.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Message sent successfully!');", true);

                
                nametxt.Text = "";
                lasttxb.Text = "";
                phonetxt.Text = "";
                emailtxt.Text = "";
                commtxt.Text = "";
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
           
            nametxt.Text = "";
            lasttxb.Text = "";
            phonetxt.Text = "";
            emailtxt.Text = "";
            commtxt.Text = "";
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Session["User"] = "LoggedIn";
            Response.Redirect("Home.aspx"); 
        }
    }
}
