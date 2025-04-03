<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="BookingConfirmation.aspx.cs" Inherits="TicketingBrosMP.BookingConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .confirmation-container {
            max-width: 700px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        }
        .confirmation-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .confirmation-number {
            font-size: 26px;
            letter-spacing: 3px;
            font-weight: bold;
            color: #198754;
            background-color: #d1e7dd;
            padding: 10px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .ticket-details {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .qr-code {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 10px;
        }
        .ticket-info {
            font-size: 14px;
            margin-top: 20px;
            padding: 15px;
            border: 1px dashed #dee2e6;
            border-radius: 8px;
            background-color: #fff8e1;
        }
        .divider {
            height: 1px;
            background-color: #dee2e6;
            margin: 20px 0;
        }
        .buttons-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn-print {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
        }
        .btn-print:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
        @media print {
            .no-print {
                display: none !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="confirmation-container">
            <div class="confirmation-header">
                <h2>🎉 Booking Confirmed! 🎉</h2>
                <p class="text-muted">Thank you for your purchase</p>
                <div class="confirmation-number">
                    <asp:Label ID="lblConfirmationNumber" runat="server"></asp:Label>
                </div>
            </div>
            
            <div class="ticket-details">
                <div class="row">
                    <div class="col-md-8">
                        <h4>Movie Details</h4>
                        <p><strong>Movie:</strong> <asp:Label ID="lblMovieTitle" runat="server"></asp:Label></p>
                        <p><strong>Date:</strong> <asp:Label ID="lblDate" runat="server"></asp:Label></p>
                        <p><strong>Time:</strong> <asp:Label ID="lblTime" runat="server"></asp:Label></p>
                        <p><strong>Seats:</strong> <asp:Label ID="lblSeats" runat="server"></asp:Label></p>
                        <p><strong>Total Paid:</strong> <asp:Label ID="lblTotalPrice" runat="server"></asp:Label></p>
                    </div>
                    <div class="col-md-4 text-center">
                        <div class="qr-code">
                            <asp:Image ID="imgQRCode" runat="server" CssClass="img-fluid" ImageUrl="~/Picture/qrcode.png" AlternateText="QR Code" />
                        </div>
                        <p class="mt-2 small">Scan at kiosk</p>
                    </div>
                </div>
            </div>
            
            <div class="ticket-info">
                <h5>Important Information:</h5>
                <ul>
                    <li>E-tickets have been sent to your registered email address.</li>
                    <li>Please arrive at least 15 minutes before the showtime.</li>
                    <li>Have your confirmation number or email ready for verification.</li>
                    <li>No refunds or exchanges permitted after purchase.</li>
                </ul>
            </div>
            
            <div class="divider"></div>
            
            <div class="buttons-container">
                <asp:Button ID="btnPrintReceipt" runat="server" Text="Print Receipt" CssClass="btn btn-print" OnClick="btnPrintReceipt_Click" />
                <asp:Button ID="btnViewBookings" runat="server" Text="View My Bookings" CssClass="btn btn-secondary" OnClick="btnViewBookings_Click" />
                <asp:Button ID="btnReturnHome" runat="server" Text="Return to Home" CssClass="btn btn-primary" OnClick="btnReturnHome_Click" />
            </div>
        </div>
    </div>
</asp:Content>