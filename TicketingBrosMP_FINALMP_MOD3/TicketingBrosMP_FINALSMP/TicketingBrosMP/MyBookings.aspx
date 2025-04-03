<%@ Page Title="My Bookings" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="MyBookings.aspx.cs" Inherits="TicketingBrosMP.MyBookings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            background-image: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
        }
        
        .bookings-container {
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transform: translateY(0);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            position: relative;
        }
        
        .bookings-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .page-title {
            color: #333;
            font-weight: 700;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
            text-align: center;
        }
        
        .page-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, #79642C 0%, #a88c40 100%);
            border-radius: 10px;
        }
        
        /* Enhanced Table Styling */
        .table {
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .table th {
            background: linear-gradient(90deg, #79642C 0%, #a88c40 100%) !important;
            color: white !important;
            font-weight: 600;
            letter-spacing: 0.5px;
            padding: 14px 15px;
            font-size: 14px;
            text-transform: uppercase;
            border: none !important;
        }
        
        .table td {
            padding: 15px;
            vertical-align: middle;
            border-color: #f1f1f1;
            font-size: 15px;
            transition: all 0.2s ease;
        }
        
        .table tbody tr {
            transition: background-color 0.2s ease;
        }
        
        .table tbody tr:nth-child(odd) {
            background-color: rgba(121, 100, 44, 0.05);
        }
        
        .table tbody tr:hover {
            background-color: rgba(121, 100, 44, 0.1);
        }
        
        /* No bookings message styling */
        .no-bookings {
            color: #856404;
            font-size: 18px;
            text-align: center;
            padding: 30px 20px;
            background-color: rgba(255, 248, 225, 0.5);
            border-radius: 12px;
            border: 1px dashed #ffeeba;
            margin: 20px 0;
            font-weight: 500;
            display: block;
        }
        
        /* Icon for no bookings message */
        .ticket-icon {
            display: block;
            font-size: 48px;
            margin-bottom: 15px;
            color: #cab36f;
        }
        
        /* Button styling */
        .btn-custom {
            background: linear-gradient(90deg, #79642C 0%, #a88c40 100%);
            border: none;
            color: white;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(121, 100, 44, 0.2);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
            width: 100%;
        }
        
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(121, 100, 44, 0.3);
            color: white;
        }
        
        /* Loading animation */
        .loading-indicator {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        
        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(121, 100, 44, 0.1);
            border-radius: 50%;
            border-top: 4px solid #79642C;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Page enter animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease forwards;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Loading indicator -->
    <div class="loading-indicator" id="loadingIndicator">
        <div class="spinner"></div>
    </div>

    <div class="container mt-5 mb-5">
        <div class="bookings-container fade-in">
            <h2 class="page-title">My Bookings</h2>
            
            <asp:GridView ID="gvBookings" runat="server" CssClass="table table-bordered table-hover text-center" 
                AutoGenerateColumns="False" EmptyDataText="" ShowHeaderWhenEmpty="False">
                <Columns>
                    <asp:BoundField DataField="MovieTitle" HeaderText="Movie" />
                    <asp:BoundField DataField="Seats" HeaderText="Seats" />
                    <asp:BoundField DataField="BookingDate" HeaderText="Date" DataFormatString="{0:MMMM d, yyyy}" />
                    <asp:BoundField DataField="ShowTime" HeaderText="Time" DataFormatString="{0:hh:mm tt}" />
                    <asp:BoundField DataField="TotalPrice" HeaderText="Total Price" DataFormatString="₱{0:N2}" />
                    <asp:BoundField DataField="ConfirmationNumber" HeaderText="Confirmation #" />
                </Columns>
            </asp:GridView>
            
            <!-- Enhanced No Bookings Message -->
            <asp:Label ID="lblNoBookings" runat="server" CssClass="no-bookings" Visible="False">
                <i class="fas fa-ticket-alt ticket-icon"></i>
                You don't have any bookings yet. Let's find a movie for you!
            </asp:Label>
            
            <div class="d-grid gap-2 mt-4">
                <asp:Button ID="btnReturnHome" runat="server" CssClass="btn btn-custom" 
                    Text="Return Home" OnClick="btnReturnHome_Click" />
            </div>
        </div>
    </div>
    
    <script>
        // Show loading when navigating away
        document.getElementById('<%= btnReturnHome.ClientID %>').addEventListener('click', function () {
            document.getElementById('loadingIndicator').style.display = 'flex';
        });

        // Hide loading indicator when page is fully loaded
        window.addEventListener('load', function () {
            document.getElementById('loadingIndicator').style.display = 'none';
        });
    </script>
</asp:Content>