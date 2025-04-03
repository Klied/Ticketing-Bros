using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
namespace TicketingBrosMP
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMovies();
            }
        }
        private void LoadMovies()
        {
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");

            using (OleDbConnection conn = new OleDbConnection(connString))
            {
                try
                {
                    conn.Open();
                    DateTime today = DateTime.Today;

                   
                    string nowShowingQuery = "SELECT Title, PosterPath FROM Movies WHERE ShowingDate <= ? AND EndDate >= ?";
                    using (OleDbCommand cmd = new OleDbCommand(nowShowingQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("?", today);
                        cmd.Parameters.AddWithValue("?", today);
                        OleDbDataReader reader = cmd.ExecuteReader();
                        DataTable dt = new DataTable();
                        dt.Load(reader);

                        pnlNowShowing.Visible = dt.Rows.Count > 0;
                        pnlNoNowShowing.Visible = dt.Rows.Count == 0;

                        rptNowShowing.DataSource = dt;
                        rptNowShowing.DataBind();
                    }

                   
                    string upcomingQuery = "SELECT Title, PosterPath FROM Movies WHERE ShowingDate > ?";
                    using (OleDbCommand cmd = new OleDbCommand(upcomingQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("?", today);
                        OleDbDataReader reader = cmd.ExecuteReader();
                        DataTable dt = new DataTable();
                        dt.Load(reader);

                        pnlUpcoming.Visible = dt.Rows.Count > 0;
                        pnlNoUpcoming.Visible = dt.Rows.Count == 0;

                        rptUpcomingMovies.DataSource = dt;
                        rptUpcomingMovies.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error loading movies: " + ex.Message + "');</script>");
                }
            }
        }
    }
}
