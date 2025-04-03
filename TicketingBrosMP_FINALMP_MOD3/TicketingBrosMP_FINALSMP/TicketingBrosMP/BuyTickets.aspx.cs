using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace TicketingBrosMP
{
    public partial class BuyTickets : Page
    {
        private Dictionary<string, List<string>> _takenSeatsCache = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (this.Header != null)
                {
                    HtmlMeta metaRefresh = new HtmlMeta();
                    metaRefresh.HttpEquiv = "refresh";
                    metaRefresh.Content = "30";
                    this.Header.Controls.Add(metaRefresh);
                }
                ClientScript.RegisterStartupScript(this.GetType(), "RefreshOnFocus", @"
                    document.addEventListener('visibilitychange', function() {
                        if (document.visibilityState === 'visible') {
                            location.reload();
                        }
                    });", true);
            }

            
            _takenSeatsCache = LoadTakenSeats();

            if (!IsPostBack)
            {
                LoadMovies();
            }
        }

        private void LoadMovies()
        {
            string movieID = Request.QueryString["MovieID"];
            if (string.IsNullOrEmpty(movieID))
            {
                Response.Write("<script>alert('No movie selected. Redirecting to homepage.');window.location='Home.aspx';</script>");
                return;
            }

            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = "SELECT ID, Title, Genre, Duration, Director, Writer, Description, PosterPath FROM Movies WHERE ID = ?";

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connString))
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ID", movieID);
                    conn.Open();
                    using (OleDbDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            rptMovies.DataSource = reader;
                            rptMovies.DataBind();
                        }
                        else
                        {
                            Response.Write("<script>alert('Movie not found. Returning to homepage.');window.location='Home.aspx';</script>");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading movie: " + ex.Message + "');</script>");
            }
        }

        private Dictionary<string, List<string>> LoadTakenSeats()
        {
            var takenSeats = new Dictionary<string, List<string>>();
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = "SELECT MovieTitle, Seats FROM TicketBookings";
            using (OleDbConnection conn = new OleDbConnection(connString))
            using (OleDbCommand cmd = new OleDbCommand(query, conn))
            {
                conn.Open();
                using (OleDbDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string movieTitle = reader["MovieTitle"].ToString();
                        string seats = reader["Seats"].ToString();
                        var seatIds = new List<string>();
                        foreach (var s in seats.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            seatIds.Add(s.Trim());
                        }
                        if (!takenSeats.ContainsKey(movieTitle))
                        {
                            takenSeats[movieTitle] = new List<string>();
                        }
                        takenSeats[movieTitle].AddRange(seatIds);
                    }
                }
            }
            return takenSeats;
        }

        public bool IsSeatTaken(object movieTitleObj, string seatId)
        {
            string movieTitle = movieTitleObj.ToString();
            if (_takenSeatsCache != null && _takenSeatsCache.ContainsKey(movieTitle))
            {
                return _takenSeatsCache[movieTitle].Contains(seatId);
            }
            return false;
        }

        public string GenerateTheaterSeats(object dataItem)
        {
            string movieTitle = DataBinder.Eval(dataItem, "Title").ToString();
            string movieId = DataBinder.Eval(dataItem, "ID").ToString();
            StringBuilder seatHtml = new StringBuilder();
            char[] rows = { 'A', 'B', 'C', 'D', 'E' };
            int seatsPerHalfRow = 4;
            int seatNumber = 1;
            foreach (char row in rows)
            {
                seatHtml.Append("<div class='seat-row'>");
                seatHtml.AppendFormat("<div class='row-label'>{0}</div>", row);
              
                for (int i = 1; i <= seatsPerHalfRow; i++)
                {
                    string seatId = $"{row}{i}";
                    bool isTaken = IsSeatTaken(movieTitle, seatId);
                    bool isPremium = row == 'D' || row == 'E';
                    seatHtml.Append("<label class='seat-label ");
                    if (isTaken) seatHtml.Append("taken ");
                    if (isPremium) seatHtml.Append("premium ");
                    seatHtml.Append("'>");
                    seatHtml.AppendFormat("<input type='checkbox' class='seat-checkbox' id='seat_{0}_{1}' name='seat_{0}' value='{2}' data-seat-info='{2}' {3} />",
                        movieId,
                        seatNumber,
                        seatId,
                        isTaken ? "disabled" : "");
                    seatHtml.Append(seatId);
                    seatHtml.Append("</label>");
                    seatNumber++;
                }
                seatHtml.Append("<div class='aisle'></div>");
               
                for (int i = seatsPerHalfRow + 1; i <= 2 * seatsPerHalfRow; i++)
                {
                    string seatId = $"{row}{i}";
                    bool isTaken = IsSeatTaken(movieTitle, seatId);
                    bool isPremium = row == 'D' || row == 'E';
                    seatHtml.Append("<label class='seat-label ");
                    if (isTaken) seatHtml.Append("taken ");
                    if (isPremium) seatHtml.Append("premium ");
                    seatHtml.Append("'>");
                    seatHtml.AppendFormat("<input type='checkbox' class='seat-checkbox' id='seat_{0}_{1}' name='seat_{0}' value='{2}' data-seat-info='{2}' {3} />",
                        movieId,
                        seatNumber,
                        seatId,
                        isTaken ? "disabled" : "");
                    seatHtml.Append(seatId);
                    seatHtml.Append("</label>");
                    seatNumber++;
                }
                seatHtml.Append("</div>");
            }
            return seatHtml.ToString();
        }

        
        protected void rptMovies_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
                int movieID = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "ID"));

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

         
            string query = @"SELECT A.ActorID, A.CastName, A.CastPhotoPath 
                     FROM Actors A 
                     INNER JOIN MovieActors MA ON A.ActorID = MA.ActorID 
                     WHERE MA.MovieID = @MovieID";

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connString))
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MovieID", movieID); 

                    conn.Open();
                    using (OleDbDataReader reader = cmd.ExecuteReader())
                    {
                        dtActors.Load(reader);
                    }
                }
            }
            catch (Exception ex)
            {
                
                Console.WriteLine("Error fetching actors: " + ex.Message);
            }

            return dtActors;
        }


        protected void btnProceedToCheckout_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string movieID = btn.CommandArgument;
            HiddenField hfMovieTitle = (HiddenField)btn.NamingContainer.FindControl("hfMovieTitle");
            string movieTitle = hfMovieTitle.Value;
            string seatField = "seat_" + movieID;
            string[] selectedSeats = Request.Form.GetValues(seatField);
            if (selectedSeats == null || selectedSeats.Length == 0)
            {
                Response.Write($"<script>alert('Please select at least one seat for {movieTitle}.');</script>");
                return;
            }
            string username = Session["Username"]?.ToString();
            if (string.IsNullOrEmpty(username))
            {
                Response.Write("<script>alert('You must be logged in to purchase tickets.');</script>");
                return;
            }
            decimal totalPrice = 0;
            foreach (var seat in selectedSeats)
            {
                bool isPremium = seat.StartsWith("D") || seat.StartsWith("E");
                totalPrice += isPremium ? 450m : 300m;
            }
            Session["SelectedSeats"] = string.Join(",", selectedSeats);
            Session["MovieTitle"] = movieTitle;
            Session["MovieID"] = movieID;
            Session["TotalPrice"] = totalPrice;
            Response.Redirect("Checkout.aspx");
        }
    }
}
