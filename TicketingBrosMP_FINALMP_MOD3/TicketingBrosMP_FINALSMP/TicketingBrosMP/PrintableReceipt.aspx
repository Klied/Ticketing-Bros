<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintableReceipt.aspx.cs" Inherits="TicketingBrosMP.PrintableReceipt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ticketing Bros - Receipt</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        @media print {
            .no-print { display: none !important; }
            body { margin: 0; padding: 0; font-size: 12px; }
            .print-container { width: 100%; max-width: 600px; padding: 0; }
        }
        
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 15px;
            background-color: #f5f5f5;
            font-size: 14px;
        }
        .print-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        .receipt-header {
            text-align: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #333;
        }
        .company-logo {
            max-width: 150px;
            margin-bottom: 8px;
        }
        .receipt-title {
            font-size: 18px;
            font-weight: bold;
            margin: 5px 0;
        }
        .receipt-subtitle {
            font-size: 14px;
            color: #555;
        }
        .receipt-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .receipt-info-col {
            flex: 1;
        }
        .receipt-label {
            font-weight: bold;
            margin-bottom: 3px;
            font-size: 13px;
        }
        .receipt-value {
            color: #333;
            margin-bottom: 10px;
        }
        .ticket-details {
            margin-bottom: 15px;
        }
        .ticket-details h3 {
            font-size: 15px;
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px solid #eee;
        }
        .ticket-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            grid-gap: 10px;
        }
        .payment-row {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
        }
        .payment-total {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            margin-top: 5px;
            border-top: 1px solid #eee;
            font-size: 16px;
            font-weight: bold;
        }
        .confirmation-number {
            font-family: 'Courier New', monospace;
            font-size: 15px;
            letter-spacing: 1px;
            padding: 8px;
            background-color: #f8f9fa;
            border-radius: 5px;
            text-align: center;
            margin: 15px 0;
        }
        .qr-section {
            text-align: center;
            margin: 15px 0;
        }
        .qr-img {
            max-width: 120px;
            height: auto;
        }
        .qr-text {
            font-size: 12px;
            color: #555;
            margin-top: 5px;
        }
        .receipt-footer {
            margin-top: 15px;
            padding-top: 10px;
            border-top: 1px solid #eee;
            font-size: 12px;
            color: #666;
            text-align: center;
        }
        .btn {
            display: inline-block;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            margin: 0 5px;
        }
        .btn-print { background-color: #28a745; color: white; }
        .btn-back { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="print-container">
            <div class="receipt-header">
                <img src="/Picture/logo.png" alt="Ticketing Bros Logo" class="company-logo" />
                <div class="receipt-title">Official Receipt</div>
                <div class="receipt-subtitle">TICKETING BROS CINEMAS</div>
            </div>
            
            <div class="receipt-info">
                <div class="receipt-info-col">
                    <div class="receipt-label">Date:</div>
                    <div class="receipt-value"><asp:Label ID="lblPurchaseDate" runat="server"></asp:Label></div>
                    
                    <div class="receipt-label">Customer:</div>
                    <div class="receipt-value"><asp:Label ID="lblCustomerName" runat="server"></asp:Label></div>
                </div>
                
                <div class="receipt-info-col">
                    <div class="receipt-label">Receipt No:</div>
                    <div class="receipt-value"><asp:Label ID="lblReceiptNumber" runat="server"></asp:Label></div>
                    
                    <div class="receipt-label">Payment:</div>
                    <div class="receipt-value">Online Payment</div>
                </div>
            </div>
            
            <div class="ticket-details">
                <h3>Booking Details</h3>
                <div class="ticket-info-grid">
                    <div>
                        <div class="receipt-label">Movie:</div>
                        <div class="receipt-value"><asp:Label ID="lblMovieTitle" runat="server"></asp:Label></div>
                    </div>
                    
                    <div>
                        <div class="receipt-label">Date:</div>
                        <div class="receipt-value"><asp:Label ID="lblDate" runat="server"></asp:Label></div>
                    </div>
                    
                    <div>
                        <div class="receipt-label">Time:</div>
                        <div class="receipt-value"><asp:Label ID="lblTime" runat="server"></asp:Label></div>
                    </div>
                    
                    <div>
                        <div class="receipt-label">Seats:</div>
                        <div class="receipt-value"><asp:Label ID="lblSeats" runat="server"></asp:Label></div>
                    </div>
                </div>
            </div>
            
            <div class="ticket-details">
                <h3>Payment Summary</h3>
                <div class="payment-row">
                    <div class="receipt-label">Ticket Price:</div>
                    <div>₱<asp:Label ID="lblTicketPrice" runat="server">250.00</asp:Label> × <asp:Label ID="lblSeatCount" runat="server"></asp:Label></div>
                </div>
                <div class="payment-row">
                    <div class="receipt-label">Subtotal:</div>
                    <div>₱<asp:Label ID="lblSubtotal" runat="server"></asp:Label></div>
                </div>
                <div class="payment-row">
                    <div class="receipt-label">Convenience Fee:</div>
                    <div>₱<asp:Label ID="lblConvenienceFee" runat="server">20.00</asp:Label></div>
                </div>
                <div class="payment-total">
                    <div>TOTAL:</div>
                    <div>₱<asp:Label ID="lblTotalPrice" runat="server"></asp:Label></div>
                </div>
            </div>
            
            <div class="confirmation-number">
                Confirmation #: <asp:Label ID="lblConfirmationNumber" runat="server"></asp:Label>
            </div>
            
            <div class="qr-section">
                <asp:Image ID="imgQRCode" runat="server" CssClass="qr-img" ImageUrl="~/Picture/qrcode.png" AlternateText="QR Code" />
                <div class="qr-text">Scan at cinema kiosk to collect tickets</div>
            </div>
            
            <div class="receipt-footer">
                <p>Thank you for choosing Ticketing Bros Cinemas!</p>
                <p style="font-style:italic;">This is your official receipt.</p>
                <p>© 2025 Ticketing Bros Cinemas</p>
            </div>
            
            <div class="text-center no-print" style="margin-top:15px; text-align:center;">
                <button type="button" class="btn btn-print" onclick="window.print();">Print Receipt</button>
                <asp:Button ID="btnBack" runat="server" Text="Home" CssClass="btn btn-back" OnClick="btnBack_Click" />
            </div>
        </div>
    </form>
</body>
</html>