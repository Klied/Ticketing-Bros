using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TicketingBrosMP
{
    public partial class RecentTicketCancellation : Page
    {
       
        private const int CANCELLATION_WINDOW_MINUTES = 5;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] == null)
                {
                    RedirectToLogin();
                    return;
                }

                LoadRecentTickets();
            }
        }

        private void RedirectToLogin()
        {
           
            Session["ReturnUrl"] = Request.Url.ToString();
            Response.Write("<script>alert('Please log in to view and manage your tickets.'); window.location='signup.aspx';</script>");
        }

        private void LoadRecentTickets()
        {
            string username = Session["Username"]?.ToString();
            if (string.IsNullOrEmpty(username))
            {
                RedirectToLogin();
                return;
            }

            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = "SELECT ID, MovieTitle, Seats, BookingTime FROM TicketBookings WHERE Username = ? ORDER BY BookingTime DESC";

            using (OleDbConnection connection = new OleDbConnection(connString))
            {
                try
                {
                    connection.Open();
                    using (OleDbCommand command = new OleDbCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Username", username);
                        using (OleDbDataReader reader = command.ExecuteReader())
                        {
                           
                            DataTable dt = new DataTable();
                            dt.Columns.Add("ID");
                            dt.Columns.Add("MovieTitle");
                            dt.Columns.Add("Seats");
                            dt.Columns.Add("BookingTime", typeof(DateTime));
                            dt.Columns.Add("CanCancel", typeof(bool));
                            dt.Columns.Add("TimeRemaining", typeof(int));

                            DateTime now = DateTime.Now;
                            bool hasRecentTickets = false;

                            while (reader.Read())
                            {
                                DateTime bookingTime = Convert.ToDateTime(reader["BookingTime"]);
                                TimeSpan elapsed = now - bookingTime;

                                
                                if (elapsed.TotalMinutes <= 10)
                                {
                                    bool canCancel = elapsed.TotalMinutes <= CANCELLATION_WINDOW_MINUTES;

                                    DataRow row = dt.NewRow();
                                    row["ID"] = reader["ID"];
                                    row["MovieTitle"] = reader["MovieTitle"];
                                    row["Seats"] = reader["Seats"];
                                    row["BookingTime"] = bookingTime;
                                    row["CanCancel"] = canCancel;

                                    
                                    int secondsRemaining = canCancel ?
                                        Math.Max(0, (CANCELLATION_WINDOW_MINUTES * 60) - (int)elapsed.TotalSeconds) : 0;
                                    row["TimeRemaining"] = secondsRemaining;

                                    dt.Rows.Add(row);

                                    if (canCancel)
                                    {
                                        hasRecentTickets = true;
                                    }
                                }
                            }

                            if (dt.Rows.Count > 0)
                            {
                                rptRecentTickets.DataSource = dt;
                                rptRecentTickets.DataBind();
                                pnlNoTickets.Visible = false;
                                btnCancelTickets.Visible = hasRecentTickets;
                            }
                            else
                            {
                                pnlNoTickets.Visible = true;
                                btnCancelTickets.Visible = false;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    LogError(ex);
                    ShowErrorMessage("There was an error loading your recent tickets. Please try again later.");
                }
            }
        }

        protected void rptRecentTickets_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
            }
        }

        protected void btnCancelTickets_Click(object sender, EventArgs e)
        {
            string username = Session["Username"]?.ToString();
            if (string.IsNullOrEmpty(username))
            {
                RedirectToLogin();
                return;
            }

            bool ticketCanceled = false;
            int cancellationCount = 0;
            List<string> cancelledSeats = new List<string>();
            string movieTitle = string.Empty;

            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");

            using (OleDbConnection connection = new OleDbConnection(connString))
            {
                try
                {
                    connection.Open();

                    foreach (RepeaterItem item in rptRecentTickets.Items)
                    {
                        CheckBox chkSeat = (CheckBox)item.FindControl("chkSeat");
                        HiddenField hfMovieTitle = (HiddenField)item.FindControl("hfMovieTitle");
                        HiddenField hfBookingID = (HiddenField)item.FindControl("hfBookingID");
                        HiddenField hfSeatNumber = (HiddenField)item.FindControl("hfSeatNumber");
                        HiddenField hfCanCancel = (HiddenField)item.FindControl("hfCanCancel");

                        if (chkSeat != null && chkSeat.Checked &&
                            hfMovieTitle != null && hfBookingID != null &&
                            hfSeatNumber != null && hfCanCancel != null)
                        {
                           
                            if (bool.Parse(hfCanCancel.Value))
                            {
                                string ticketId = hfBookingID.Value;
                                string seatNumber = hfSeatNumber.Value;
                                movieTitle = hfMovieTitle.Value;

                               
                                string checkQuery = "SELECT BookingTime FROM TicketBookings WHERE ID = ? AND Username = ?";
                                using (OleDbCommand checkCommand = new OleDbCommand(checkQuery, connection))
                                {
                                    checkCommand.Parameters.AddWithValue("@ID", ticketId);
                                    checkCommand.Parameters.AddWithValue("@Username", username);

                                    object result = checkCommand.ExecuteScalar();
                                    if (result != null)
                                    {
                                        DateTime bookingTime = Convert.ToDateTime(result);
                                        TimeSpan elapsed = DateTime.Now - bookingTime;

                                        if (elapsed.TotalMinutes <= CANCELLATION_WINDOW_MINUTES)
                                        {
                                            
                                            string deleteQuery = "DELETE FROM TicketBookings WHERE ID = ? AND Username = ?";
                                            using (OleDbCommand command = new OleDbCommand(deleteQuery, connection))
                                            {
                                                command.Parameters.AddWithValue("@ID", ticketId);
                                                command.Parameters.AddWithValue("@Username", username);

                                                int rowsAffected = command.ExecuteNonQuery();
                                                if (rowsAffected > 0)
                                                {
                                                    ticketCanceled = true;
                                                    cancellationCount += rowsAffected;
                                                    cancelledSeats.Add(seatNumber);
                                                }
                                            }
                                        }
                                        else
                                        {
                                            
                                            ShowErrorMessage("The cancellation period has expired for one or more selected tickets.");
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    LogError(ex);
                    ShowErrorMessage("An error occurred while canceling tickets. Please try again later.");
                    return;
                }
            }

            if (ticketCanceled)
            {
                string message;
                if (cancellationCount == 1)
                {
                    message = $"Your ticket for seat {cancelledSeats[0]} has been successfully canceled.";
                }
                else
                {
                    message = $"{cancellationCount} tickets have been successfully canceled: {string.Join(", ", cancelledSeats)}.";
                }

               
                Response.Write($"<script>alert('{message}'); window.location='Home.aspx';</script>");
            }
            else
            {
                ShowErrorMessage("No tickets were selected or there was an error in the cancellation process.");
            }
        }

        private void ShowErrorMessage(string message)
        {
            
            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                $"alert('{message}');", true);
        }

        private void LogError(Exception ex)
        {
           
            System.Diagnostics.Debug.WriteLine($"Error in RecentTicketCancellation.aspx: {ex.Message}");
            
            System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
        }
    }
}