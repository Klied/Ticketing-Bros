<%@ Page Title="About Us" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="about.aspx.cs" Inherits="Ticketing2.about" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>About Us - Ticketing Bros</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <h1 class="text-center">About Us</h1>
        <p class="text-center">Welcome to Ticketing Bros! We are dedicated to providing you with the best movie ticketing experience.</p>
        <div class="mt-4">
            <h3>Our Mission</h3>
            <p>At Ticketing Bros, our mission is to make movie ticket booking easy and accessible for everyone. We strive to offer a seamless experience from browsing movies to booking tickets.</p>
        </div>
        <div class="mt-4">
            <h3>Our Values</h3>
            <ul>
                <li>Customer Satisfaction: We prioritize our customers and aim to exceed their expectations.</li>
                <li>Integrity: We conduct our business with honesty and transparency.</li>
                <li>Innovation: We continuously seek to improve our services and embrace new technologies.</li>
            </ul>
        </div>
        <div class="mt-4">
            <h3>Contact Us</h3>
            <p>If you have any questions or feedback, feel free to reach out to us at <strong>TicketingBros@gmail.com</strong> or call us at <strong>+63 932 555 6789</strong>.</p>
        </div>
    </div>
</asp:Content>