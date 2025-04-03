using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;

namespace TicketingBrosMP
{
    public partial class MyBookings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] == null)
                {
                    Response.Write("<script>alert('You must be logged in to view your bookings.'); window.location='signup.aspx';</script>");
                    return;
                }
                
                LoadBookings();
            }
        }

        private void LoadBookings()
        {
            string username = Session["Username"].ToString();
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = "SELECT MovieTitle, Seats, BookingDate, ShowTime, TotalPrice, ConfirmationNumber FROM TicketBookings WHERE Username = ? ORDER BY BookingDate DESC";

            using (OleDbConnection conn = new OleDbConnection(connString))
            {
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();

                    using (OleDbDataAdapter adapter = new OleDbDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvBookings.DataSource = dt;
                        gvBookings.DataBind();

                       
                        lblNoBookings.Visible = (dt.Rows.Count == 0);
                    }
                }
            }
        }

        protected void btnReturnHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }
    }
}
