<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="TicketingBrosMP.Checkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .checkout-container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        .section-title {
            border-bottom: 2px solid #f8f9fa;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .order-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        .seats-display {
            font-size: 18px;
            letter-spacing: 1px;
        }
        .payment-icons {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .payment-icon {
            width: 50px;
            height: 30px;
            background-color: #e9ecef;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 10px;
        }
        .ticket-info {
            font-size: 14px;
            margin-top: 20px;
            padding: 15px;
            border: 1px dashed #dee2e6;
            border-radius: 8px;
            background-color: #fff8e1;
        }
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: block;
            height: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5 mb-5">
        <div class="checkout-container">
            <h2 class="text-center mb-4">🎬 Complete Your Purchase 🎬</h2>
            
            <div class="order-summary">
                <h4 class="section-title">Order Summary</h4>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Movie:</strong> <asp:Label ID="lblMovieTitle" runat="server"></asp:Label></p>
                        <p><strong>Date:</strong> <asp:Label ID="lblDate" runat="server"></asp:Label></p>
                        <p><strong>Time:</strong> <asp:Label ID="lblTime" runat="server"></asp:Label></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Selected Seats:</strong></p>
                        <p class="seats-display"><asp:Label ID="lblSelectedSeats" runat="server"></asp:Label></p>
                        <p><strong>Total Price:</strong> ₱<asp:Label ID="lblTotalPrice" runat="server"></asp:Label></p>
                    </div>
                </div>
            </div>
            
            <!-- General booking error message -->
            <div id="bookingError" class="error-message text-center mb-3"></div>
            
            <div class="payment-section">
                <h4 class="section-title">Payment Information</h4>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="txtCardName" class="form-label">Name on Card</label>
                        <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control" placeholder="First Name, Last Name"></asp:TextBox>
                        <span id="cardNameError" class="error-message"></span>
                    </div>
                    <div class="col-md-6">
                        <label for="txtCardNumber" class="form-label">Card Number</label>
                        <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="1234 5678 9012 3456" MaxLength="16"></asp:TextBox>
                        <span id="cardNumberError" class="error-message"></span>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="txtExpMonth" class="form-label">Expiry Month</label>
                        <asp:DropDownList ID="txtExpMonth" runat="server" CssClass="form-select">
                            <asp:ListItem Text="01" Value="01"></asp:ListItem>
                            <asp:ListItem Text="02" Value="02"></asp:ListItem>
                            <asp:ListItem Text="03" Value="03"></asp:ListItem>
                            <asp:ListItem Text="04" Value="04"></asp:ListItem>
                            <asp:ListItem Text="05" Value="05"></asp:ListItem>
                            <asp:ListItem Text="06" Value="06"></asp:ListItem>
                            <asp:ListItem Text="07" Value="07"></asp:ListItem>
                            <asp:ListItem Text="08" Value="08"></asp:ListItem>
                            <asp:ListItem Text="09" Value="09"></asp:ListItem>
                            <asp:ListItem Text="10" Value="10"></asp:ListItem>
                            <asp:ListItem Text="11" Value="11"></asp:ListItem>
                            <asp:ListItem Text="12" Value="12"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label for="txtExpYear" class="form-label">Expiry Year</label>
                        <asp:DropDownList ID="txtExpYear" runat="server" CssClass="form-select">
                            <asp:ListItem Text="2025" Value="2025"></asp:ListItem>
                            <asp:ListItem Text="2026" Value="2026"></asp:ListItem>
                            <asp:ListItem Text="2027" Value="2027"></asp:ListItem>
                            <asp:ListItem Text="2028" Value="2028"></asp:ListItem>
                            <asp:ListItem Text="2029" Value="2029"></asp:ListItem>
                            <asp:ListItem Text="2030" Value="2030"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label for="txtCVV" class="form-label">CVV</label>
                        <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="3" TextMode="Password"></asp:TextBox>
                        <span id="cvvError" class="error-message"></span>
                    </div>
                </div>
                <div class="payment-icons">
                    <div class="payment-icon">VISA</div>
                    <div class="payment-icon">MASTER</div>
                    <div class="payment-icon">AMEX</div>
                </div>
            </div>

            <div class="customer-info mt-4">
                <h4 class="section-title">Customer Information</h4>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="txtEmail" class="form-label">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="email@example.com" TextMode="Email"></asp:TextBox>
                        <span id="emailError" class="error-message"></span>
                    </div>
                    <div class="col-md-6">
                        <label for="txtPhone" class="form-label">Phone Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="09XX XXX XXXX" MaxLength="11"></asp:TextBox>
                        <span id="phoneError" class="error-message"></span>
                    </div>
                </div>
            </div>

            <div class="ticket-info">
                <p class="mb-0"><strong>Important:</strong> Your e-tickets will be sent to your email address after purchase. Please arrive 15 minutes before the showtime. Have your confirmation email ready for verification.</p>
            </div>

            <div class="d-grid gap-2 mt-4">
                <asp:Button ID="btnConfirmPurchase" runat="server" Text="Confirm Purchase" CssClass="btn btn-primary btn-lg" OnClick="btnConfirmPurchase_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary" OnClick="btnCancel_Click" />
            </div>
        </div>
    </div>
</asp:Content>