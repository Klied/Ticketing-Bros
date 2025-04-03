using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TicketingBrosMP
{
    public partial class upcoming : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUpcomingMovies();
            }
        }

        private void LoadUpcomingMovies()
        {
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = @"
                SELECT ID, Title, Genre, Duration, Director, Writer, Description, PosterPath,
                       ShowingDate, ImdbLink
                FROM Movies
                WHERE ShowingDate > Date()
                ORDER BY ShowingDate ASC";

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connString))
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    conn.Open();
                    using (OleDbDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dtMovies = new DataTable();
                        dtMovies.Load(reader);

                        rptUpcomingMovies.DataSource = dtMovies;
                        rptUpcomingMovies.DataBind();
                        pnlNoMovies.Visible = dtMovies.Rows.Count == 0;
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading upcoming movies: " + ex.Message + "');</script>");
            }
        }

        protected void rptUpcomingMovies_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = e.Item.DataItem as DataRowView;
                int movieID = Convert.ToInt32(row["ID"]);

                Repeater rptCast = e.Item.FindControl("rptCast") as Repeater;
                if (rptCast != null)
                {
                    DataTable dtActors = GetActorsByMovieID(movieID);
                    rptCast.DataSource = dtActors;
                    rptCast.DataBind();
                }
            }
        }

        private DataTable GetActorsByMovieID(int movieID)
        {
            DataTable dtActors = new DataTable();
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = @"
                SELECT A.ActorID, A.CastName, A.CastPhotoPath
                FROM Actors A
                INNER JOIN MovieActors MA ON A.ActorID = MA.ActorID
                WHERE MA.MovieID = ?"; 

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connString))
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("?", movieID);
                    conn.Open();
                    using (OleDbDataReader reader = cmd.ExecuteReader())
                    {
                        dtActors.Load(reader);
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading actors: " + ex.Message + "');</script>");
            }

            return dtActors;
        }

        protected string GetUrl(string hyperlinkField)
        {
            string[] parts = hyperlinkField.Split('#');
            return (parts.Length >= 2) ? parts[1] : hyperlinkField;
        }
    }
}