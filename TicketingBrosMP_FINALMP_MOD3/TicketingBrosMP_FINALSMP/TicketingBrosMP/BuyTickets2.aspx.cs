using System;
using System.Data.OleDb;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TicketingBrosMP
{
    public partial class BuyTickets2 : Page
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
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source="
                                + Server.MapPath("~/App_Data/TicketingBros.mdb");
            
            string query = "SELECT ID, Title, Genre, Duration, PosterPath FROM Movies WHERE ShowingDate <= Date() ORDER BY ShowingDate DESC";

            using (OleDbConnection conn = new OleDbConnection(connString))
            {
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    conn.Open();
                    rptMovieList.DataSource = cmd.ExecuteReader();
                    rptMovieList.DataBind();
                }
            }
        }

        protected void btnBuy_Click(object sender, CommandEventArgs e)
        {
            string movieID = e.CommandArgument.ToString();
            Response.Redirect("BuyTickets.aspx?MovieID=" + movieID);
        }
    }
}
