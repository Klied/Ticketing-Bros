using System;
using System.Data.OleDb;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace TicketingBrosMP
{
    public partial class Checkout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] == null)
                {
                    Response.Write("<script>alert('You must be logged in to proceed with checkout.');window.location='Login.aspx';</script>");
                    return;
                }

                if (Session["MovieTitle"] == null || Session["SelectedSeats"] == null || Session["TotalPrice"] == null)
                {
                    Response.Write("<script>alert('No ticket selection found. Please select seats first.');window.location='Home.aspx';</script>");
                    return;
                }

                lblMovieTitle.Text = Session["MovieTitle"].ToString();
                lblSelectedSeats.Text = Session["SelectedSeats"].ToString().Replace(",", ", ");
                lblTotalPrice.Text = Session["TotalPrice"].ToString();

                DateTime showDate = DateTime.Now.AddDays(1);
                Session["BookingDate"] = showDate.ToString("yyyy-MM-dd");
                Session["BookingTime"] = "19:00";

                lblDate.Text = showDate.ToString("dddd, MMMM d, yyyy");
                lblTime.Text = "7:00 PM";

                if (Session["Email"] != null)
                {
                    txtEmail.Text = Session["Email"].ToString();
                }

                AddClientSideValidation();
            }
        }

        private void AddClientSideValidation()
        {

            string script = @"
                // Prevent form submission if validation fails
                if (typeof (Sys) !== 'undefined') {
                    var prm = Sys.WebForms.PageRequestManager.getInstance();
                    if (prm != null) {
                        prm.add_initializeRequest(checkValidation);
                    }
                }

                function checkValidation(sender, args) {
                    if (!validateForm()) {
                        args.set_cancel(true);
                    }
                }

                function validateNumeric(evt) {
                    var charCode = (evt.which) ? evt.which : evt.keyCode;
                    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                        return false;
                    }
                    return true;
                }

                function validateForm() {
                    // Clear all error messages
                    clearErrorMessages();
                    
                    var isValid = true;

                    // Card Name validation
                    var cardName = document.getElementById('" + txtCardName.ClientID + @"').value;
                    if (cardName.trim() === '') {
                        document.getElementById('cardNameError').innerHTML = 'Name on card is required';
                        isValid = false;
                    }

                    // Card Number validation
                    var cardNumber = document.getElementById('" + txtCardNumber.ClientID + @"').value;
                    if (cardNumber.trim() === '') {
                        document.getElementById('cardNumberError').innerHTML = 'Card number is required';
                        isValid = false;
                    } else if (!/^\d+$/.test(cardNumber)) {
                        document.getElementById('cardNumberError').innerHTML = 'Card number must contain only digits';
                        isValid = false;
                    } else if (cardNumber.length !== 16) {
                        document.getElementById('cardNumberError').innerHTML = 'Card number must be 16 digits';
                        isValid = false;
                    }

                    // CVV validation
                    var cvv = document.getElementById('" + txtCVV.ClientID + @"').value;
                    if (cvv.trim() === '') {
                        document.getElementById('cvvError').innerHTML = 'CVV is required';
                        isValid = false;
                    } else if (!/^\d+$/.test(cvv)) {
                        document.getElementById('cvvError').innerHTML = 'CVV must contain only digits';
                        isValid = false;
                    } else if (cvv.length !== 3) {
                        document.getElementById('cvvError').innerHTML = 'CVV must be 3 digits';
                        isValid = false;
                    }

                    // Email validation
                    var email = document.getElementById('" + txtEmail.ClientID + @"').value;
                    if (email.trim() === '') {
                        document.getElementById('emailError').innerHTML = 'Email is required';
                        isValid = false;
                    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                        document.getElementById('emailError').innerHTML = 'Please enter a valid email address';
                        isValid = false;
                    }

                    // Phone validation
                    var phone = document.getElementById('" + txtPhone.ClientID + @"').value;
                    if (phone.trim() === '') {
                        document.getElementById('phoneError').innerHTML = 'Phone number is required';
                        isValid = false;
                    } else if (!/^\d+$/.test(phone)) {
                        document.getElementById('phoneError').innerHTML = 'Phone number must contain only digits';
                        isValid = false;
                    } else if (phone.length !== 11) {
                        document.getElementById('phoneError').innerHTML = 'Phone number must be 11 digits';
                        isValid = false;
                    }

                    return isValid;
                }

                function clearErrorMessages() {
                    var errorElements = document.getElementsByClassName('error-message');
                    for (var i = 0; i < errorElements.length; i++) {
                        errorElements[i].innerHTML = '';
                    }
                }";

            
            ClientScript.RegisterClientScriptBlock(this.GetType(), "ValidationScript", script, true);

           
            txtCardNumber.Attributes.Add("onkeypress", "return validateNumeric(event)");
            txtCVV.Attributes.Add("onkeypress", "return validateNumeric(event)");
            txtPhone.Attributes.Add("onkeypress", "return validateNumeric(event)");

            
            btnConfirmPurchase.OnClientClick = "return validateForm();";
        }

        protected void btnConfirmPurchase_Click(object sender, EventArgs e)
        {
            
            if (!ValidateForm())
            {
                return;
            }

            string username = Session["Username"].ToString();
            string movieTitle = Session["MovieTitle"].ToString();
            string seats = Session["SelectedSeats"].ToString();
            decimal totalPrice = Convert.ToDecimal(Session["TotalPrice"]);
            string email = txtEmail.Text;
            string phone = txtPhone.Text;
            DateTime bookingDate = DateTime.Parse(Session["BookingDate"].ToString());
            DateTime bookingTime = DateTime.ParseExact(Session["BookingTime"].ToString(), "HH:mm", null);
            string paymentMethod = "Credit Card";
            string confirmationNumber = GenerateConfirmationNumber();

            
            if (HasExistingBooking(username, movieTitle, seats))
            {
                
                ScriptManager.RegisterStartupScript(this, GetType(), "ExistingBooking",
                    "document.getElementById('bookingError').innerHTML = 'You have already booked these seats for this movie.';", true);
                return;
            }

            
            if (SaveBooking(username, movieTitle, seats, totalPrice, email, phone, bookingDate, bookingTime, paymentMethod, confirmationNumber))
            {
                Session["ConfirmationNumber"] = confirmationNumber;
                Response.Redirect("BookingConfirmation.aspx");
            }
            else
            {
                
                ScriptManager.RegisterStartupScript(this, GetType(), "BookingError",
                    "document.getElementById('bookingError').innerHTML = 'There was an error processing your booking. Please try again.';", true);
            }
        }

        private bool ValidateForm()
        {
            
            if (string.IsNullOrEmpty(txtCardName.Text) ||
                string.IsNullOrEmpty(txtCardNumber.Text) ||
                string.IsNullOrEmpty(txtCVV.Text) ||
                string.IsNullOrEmpty(txtEmail.Text) ||
                string.IsNullOrEmpty(txtPhone.Text))
            {
                return false;
            }

            if (!IsNumeric(txtCardNumber.Text) || txtCardNumber.Text.Length != 16)
            {
                return false;
            }

            if (!IsNumeric(txtCVV.Text) || txtCVV.Text.Length != 3)
            {
                return false;
            }

            if (!IsNumeric(txtPhone.Text) || txtPhone.Text.Length != 11)
            {
                return false;
            }

            if (!IsValidEmail(txtEmail.Text))
            {
                return false;
            }

            return true;
        }

        private bool IsNumeric(string input)
        {
            return Regex.IsMatch(input, @"^\d+$");
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private bool SaveBooking(string username, string movieTitle, string seats, decimal totalPrice, string email, string phone, DateTime bookingDate, DateTime bookingTime, string paymentMethod, string confirmationNumber)
        {
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");

            string query = @"INSERT INTO TicketBookings 
                (Username, MovieTitle, Seats, TotalPrice, Email, Phone, BookingDate, ShowTime, PaymentMethod, ConfirmationNumber, BookingTime) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try
            {
                using (OleDbConnection conn = new OleDbConnection(connString))
                {
                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@MovieTitle", movieTitle);
                        cmd.Parameters.AddWithValue("@Seats", seats);
                        cmd.Parameters.Add("@TotalPrice", OleDbType.Currency).Value = totalPrice;
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Phone", phone);
                        cmd.Parameters.Add("@BookingDate", OleDbType.Date).Value = bookingDate;
                        cmd.Parameters.Add("@ShowTime", OleDbType.Date).Value = bookingTime;
                        cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                        cmd.Parameters.AddWithValue("@ConfirmationNumber", confirmationNumber);
                        cmd.Parameters.Add("@BookingTime", OleDbType.Date).Value = DateTime.Now;

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                
                System.Diagnostics.Debug.WriteLine("Database error: " + ex.Message);
                return false;
            }
        }

        private bool HasExistingBooking(string username, string movieTitle, string seats)
        {
            string connString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + Server.MapPath("~/App_Data/TicketingBros.mdb");
            string query = "SELECT COUNT(*) FROM TicketBookings WHERE Username = ? AND MovieTitle = ? AND Seats = ?";

            using (OleDbConnection conn = new OleDbConnection(connString))
            {
                using (OleDbCommand cmd = new OleDbCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@MovieTitle", movieTitle);
                    cmd.Parameters.AddWithValue("@Seats", seats);

                    conn.Open();
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
        }

        private string GenerateConfirmationNumber()
        {
            return Guid.NewGuid().ToString("N").Substring(0, 8).ToUpper();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Session["SelectedSeats"] = null;
            Session["MovieTitle"] = null;
            Session["TotalPrice"] = null;
            Response.Redirect("Home.aspx");
        }
    }
}