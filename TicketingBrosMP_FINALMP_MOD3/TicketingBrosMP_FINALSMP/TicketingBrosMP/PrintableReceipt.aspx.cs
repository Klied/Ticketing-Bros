using System;
using System.Data.OleDb;
using System.Web.UI;

namespace TicketingBrosMP
{
    public partial class PrintableReceipt : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["MovieTitle"] == null ||
                    Session["BookingDate"] == null ||
                    Session["BookingTime"] == null ||
                    Session["SelectedSeats"] == null ||
                    Session["TotalPrice"] == null)
                {
                    Response.Write("<script>alert('Receipt information not found. Please return to booking.');window.location='Home.aspx';</script>");
                    return;
                }

                lblPurchaseDate.Text = DateTime.Now.ToString("MMM d, yyyy");
                lblCustomerName.Text = Session["CustomerName"]?.ToString() ?? "Valued Customer";

                string confirmationNumber = Session["ConfirmationNumber"]?.ToString() ??
                                          (Session["RetrievedConfirmation"]?.ToString() ?? GenerateRandomConfirmation());

                lblReceiptNumber.Text = "R" + DateTime.Now.ToString("yyMMdd") + confirmationNumber.Substring(Math.Max(0, confirmationNumber.Length - 4));
                lblMovieTitle.Text = Session["MovieTitle"]?.ToString() ?? "N/A";
                lblDate.Text = Convert.ToDateTime(Session["BookingDate"]).ToString("ddd, MMM d, yyyy");
                lblTime.Text = DateTime.TryParse(Session["BookingTime"]?.ToString(), out DateTime showTime)
                    ? showTime.ToString("h:mm tt")
                    : "N/A";

                string seats = Session["SelectedSeats"]?.ToString() ?? "N/A";
                lblSeats.Text = seats.Replace(",", ", ");
                int seatCount = !string.IsNullOrEmpty(seats) && seats != "N/A" ? seats.Split(',').Length : 0;
                lblSeatCount.Text = seatCount.ToString();

                decimal ticketPrice = 250.00m;
                decimal subtotal = ticketPrice * seatCount;
                lblSubtotal.Text = subtotal.ToString("0.00");

                decimal convenienceFeePerTicket = 50.00m;
                decimal totalConvenienceFee = convenienceFeePerTicket * seatCount;
                lblConvenienceFee.Text = totalConvenienceFee.ToString("0.00");

                decimal calculatedTotal = subtotal + totalConvenienceFee;

                decimal storedTotal;
                if (decimal.TryParse(Session["TotalPrice"]?.ToString(), out storedTotal))
                {
                    lblTotalPrice.Text = storedTotal.ToString("0.00");
                }
                else
                {
                    lblTotalPrice.Text = calculatedTotal.ToString("0.00");
                }

                lblConfirmationNumber.Text = confirmationNumber;

                //Save receipt number to the database
                SaveReceiptToDatabase(confirmationNumber);
            }
        }

        private string GenerateRandomConfirmation()
        {
            return "TB" + DateTime.Now.ToString("yyMMdd") + new Random().Next(1000, 9999).ToString();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }

        private void SaveReceiptToDatabase(string confirmationNumber)
        {
            try
            {
                string connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=|DataDirectory|/TicketingBrosDB.accdb;";
                using (OleDbConnection conn = new OleDbConnection(connStr))
                {
                    conn.Open();

                    
                    string checkQuery = "SELECT COUNT(*) FROM Receipts WHERE ReceiptNumber = ?";
                    using (OleDbCommand checkCmd = new OleDbCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("?", confirmationNumber);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            return; 
                        }
                    }

                    
                    string insertQuery = "INSERT INTO Receipts (ReceiptNumber, MovieTitle, BookingDate, BookingTime, SelectedSeats, TotalPrice) VALUES (?, ?, ?, ?, ?, ?)";
                    using (OleDbCommand cmd = new OleDbCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("?", confirmationNumber);
                        cmd.Parameters.AddWithValue("?", Session["MovieTitle"]?.ToString() ?? "N/A");
                        cmd.Parameters.AddWithValue("?", Session["BookingDate"]);
                        cmd.Parameters.AddWithValue("?", Session["BookingTime"]?.ToString() ?? "N/A");
                        cmd.Parameters.AddWithValue("?", Session["SelectedSeats"]?.ToString() ?? "N/A");
                        cmd.Parameters.AddWithValue("?", lblTotalPrice.Text);

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error saving receipt to the database: " + ex.Message + "');</script>");
            }
        }
    }
}
