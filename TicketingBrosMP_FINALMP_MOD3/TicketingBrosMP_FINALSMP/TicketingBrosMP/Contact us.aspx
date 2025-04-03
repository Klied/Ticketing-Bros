<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Contact us.aspx.cs" Inherits="TicketingBrosMP.Contact_us" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-container {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            font-weight: bold;
        }
        .contact-info {
            text-align: center;
            margin-top: 20px;
        }
        .contact-info p {
            font-size: 16px;
            font-weight: bold;
            margin: 5px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <h2 class="text-center text-dark fw-bold">Contact Us</h2>
        
        <div class="form-container">
            <div class="form-group">
                <label for="nametxt">First Name:</label>
                <asp:TextBox ID="nametxt" runat="server" CssClass="form-control" MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="nametxt" 
                    ErrorMessage="Please enter your first name." ForeColor="Red" ValidationGroup="ContactForm"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="lasttxb">Last Name:</label>
                <asp:TextBox ID="lasttxb" runat="server" CssClass="form-control" MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="lasttxb" 
                    ErrorMessage="Please enter your last name." ForeColor="Red" ValidationGroup="ContactForm"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="phonetxt">Phone Number:</label>
                <asp:TextBox ID="phonetxt" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="phonetxt" 
                    ErrorMessage="Please enter a valid phone number (e.g., 09123456789)." ValidationExpression="^(09|\+639)\d{9}$" 
                    ForeColor="Red" ValidationGroup="ContactForm"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="emailtxt">Email:</label>
                <asp:TextBox ID="emailtxt" runat="server" CssClass="form-control" TextMode="Email" MaxLength="50"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="emailtxt" 
                    ErrorMessage="Please enter your email address." ForeColor="Red" ValidationGroup="ContactForm"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="commtxt">Message:</label>
                <asp:TextBox ID="commtxt" runat="server" CssClass="form-control" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="commtxt" 
                    ErrorMessage="Please enter your message." ForeColor="Red" ValidationGroup="ContactForm"></asp:RequiredFieldValidator>
            </div>

            <div class="button-container text-center">
                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Submit" CssClass="btn btn-primary" ValidationGroup="ContactForm" />
                <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Cancel" CssClass="btn btn-secondary" />
            </div>
        </div>

        <div class="contact-info">
            <h3>Our Contact Details</h3>
            <p>📞 Phone: 09493177122</p>
            <p>📧 Email: TicketingBros@gmail.com</p>
            <p>📍 Location: Mapúa Malayan Colleges Laguna</p>
        </div>
    </div>
</asp:Content>
