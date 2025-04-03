<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="about us.aspx.cs" Inherits="TicketingBrosMP.about_us" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .about-container {
            max-width: 800px;
            margin: auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .about-title {
            text-align: center;
            font-size: 32px;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 20px;
        }
        .about-text {
            font-size: 18px;
            line-height: 1.6;
            text-align: justify;
            color: #495057;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <div class="about-container">
            <h2 class="about-title">About Us</h2>
            <p class="about-text">
                <asp:Label ID="Label1" runat="server" ForeColor="Black" CssClass="lead" 
                    Text="Ticketing Bros was founded by a dynamic team of four passionate students from Mapúa Malayan Colleges Laguna: Kenneth Denzel Villas, Lorenzo Okol, Vincent Trayvilla, and Yuan Umali. Inspired by our love for cinema and technology, we embarked on a journey to revolutionize the movie ticketing experience.">
                </asp:Label>
            </p>
            <p class="about-text">
                <asp:Label ID="Label2" runat="server" ForeColor="Black" CssClass="lead" 
                    Text="Our mission is to create a seamless, user-friendly, and efficient platform that allows moviegoers to book tickets effortlessly. With real-time updates, a smooth reservation system, and a commitment to customer satisfaction, Ticketing Bros aims to make every cinema visit stress-free and enjoyable.">
                </asp:Label>
            </p>
            <p class="about-text">
                <asp:Label ID="Label3" runat="server" ForeColor="Black" CssClass="lead" 
                    Text="As students of technology and innovation, we believe in harnessing digital solutions to enhance everyday experiences. Through Ticketing Bros, we strive to bridge the gap between movie lovers and their favorite films, ensuring that the joy of cinema remains just a click away.">
                </asp:Label>
            </p>
            <p class="about-text text-center fw-bold">
                <asp:Label ID="Label4" runat="server" ForeColor="Black" CssClass="lead" 
                    Text="Join us in redefining movie ticket booking fast, easy, and reliable. Welcome to Ticketing Bros, where the magic of movies meets the convenience of technology!">
                </asp:Label>
            </p>
        </div>
    </div>
</asp:Content>
