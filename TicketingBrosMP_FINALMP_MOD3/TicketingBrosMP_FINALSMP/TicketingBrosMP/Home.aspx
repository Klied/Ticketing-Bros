<%@ Page Title="Home" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TicketingBrosMP.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .carousel-container {
            max-width: 100%;
            margin: auto;
        }

        .carousel-inner img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }

        .video-container {
            max-width: 800px;
            margin: auto;
            text-align: center;
        }

        .video-container iframe {
            width: 100%;
            height: 450px;
            border-radius: 10px;
        }

        .logo-container img {
            width: 150px;
            height: auto;
        }

        .no-movies-message {
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border-radius: 10px;
            font-size: 1.5rem;
            color: #6c757d;
            font-weight: bold;
        }

        .hero-banner {
            background-image: url('Picture/herobanner.png');
            background-size: cover;
            background-position: center;
            height: 500px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            margin-bottom: 30px;
            border-radius: 10px;
        }

        .hero-banner h1 {
            font-size: 3rem;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
        }

        .hero-banner p {
            font-size: 1.2rem;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <div class="hero-banner">
            <div>
                
            </div>
        </div>

        <div class="row align-items-center mb-5">
            <div class="col-md-4 text-center">
                <img src="Picture/logo.png" class="img-fluid" alt="Website Logo">
            </div>
            <div class="col-md-8">
                <div class="video-container">
                    <h2 class="text-center text-dark fw-bold">Featured Movie Trailer</h2>
                    <iframe src="https://www.youtube.com/embed/2zQtb0H1QEs" frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                    </iframe>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h2 class="text-center text-dark fw-bold">Now Showing</h2>
                <asp:Panel ID="pnlNowShowing" runat="server" Visible="true">
                    <div id="movieCarousel" class="carousel slide carousel-container" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <asp:Repeater ID="rptNowShowing" runat="server">
                                <ItemTemplate>
                                    <div class="carousel-item <%# Container.ItemIndex == 0 ? "active" : "" %>">
                                        <img src='<%# Eval("PosterPath") %>' class="d-block w-100" alt='<%# Eval("Title") %>'>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#movieCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#movieCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        </button>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlNoNowShowing" runat="server" CssClass="no-movies-message" Visible="false">
                    No Movies Currently Showing
                </asp:Panel>
            </div>

            <div class="col-md-6">
                <h2 class="text-center text-dark fw-bold">Upcoming Movies</h2>
                <asp:Panel ID="pnlUpcoming" runat="server" Visible="true">
                    <div id="upcomingMovieCarousel" class="carousel slide carousel-container" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <asp:Repeater ID="rptUpcomingMovies" runat="server">
                                <ItemTemplate>
                                    <div class="carousel-item <%# Container.ItemIndex == 0 ? "active" : "" %>">
                                        <img src='<%# Eval("PosterPath") %>' class="d-block w-100" alt='<%# Eval("Title") %>'>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#upcomingMovieCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#upcomingMovieCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        </button>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlNoUpcoming" runat="server" CssClass="no-movies-message" Visible="false">
                    No Upcoming Movies Available
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>