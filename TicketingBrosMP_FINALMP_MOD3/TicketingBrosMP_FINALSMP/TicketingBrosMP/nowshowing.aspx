<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="nowshowing.aspx.cs" Inherits="TicketingBrosMP.nowshowing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    body {
        background-color: #f4f4f4;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }
    .movie-container {
        display: flex;
        align-items: flex-start;
        gap: 30px;
        margin-bottom: 40px;
        padding: 30px;
        background: linear-gradient(135deg, #ffffff 0%, #f9f9f0 100%);
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
        position: relative;
        overflow: hidden;
        border: 1px solid #c4a545;
    }
    .movie-container:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
    }
    .movie-poster {
        width: 300px;
        height: 450px;
        border-radius: 15px;
        object-fit: cover;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        transition: transform 0.3s ease;
    }
    .movie-container:hover .movie-poster {
        transform: scale(1.03);
    }
    .movie-details {
        flex: 1;
        color: #3c3224;
    }
    .movie-title {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 15px;
        color: #4a3b27;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    }
    .movie-title a {
        color: inherit;
        text-decoration: none;
        transition: color 0.3s ease;
    }
    .movie-title a:hover {
        color: #8b6b2a;
        text-decoration: underline;
    }
    .movie-meta {
        font-size: 16px;
        color: #5c4b33;
        margin-bottom: 8px;
        line-height: 1.5;
    }
    .movie-description {
        margin-top: 20px;
        font-size: 17px;
        line-height: 1.7;
        color: #3c3224;
        text-align: justify;
    }
    .cast-container {
        margin-top: 25px;
    }
    .cast-title {
        font-size: 22px;
        font-weight: 700;
        margin-bottom: 20px;
        color: #4a3b27;
        border-bottom: 2px solid #c4a545;
        padding-bottom: 10px;
    }
    .cast-list {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }
    .cast-member {
        width: 140px;
        text-align: center;
        transition: transform 0.3s ease;
    }
    .cast-member:hover {
        transform: scale(1.05);
    }
    .cast-photo {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        margin-bottom: 10px;
        border: 3px solid #c4a545;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }
    .cast-name {
        font-size: 15px;
        font-weight: 600;
        color: #4a3b27;
    }
    .now-showing-badge {
        position: absolute;
        top: 20px;
        left: 20px;
        background: #c4a545;
        color: white;
        font-weight: bold;
        font-size: 16px;
        padding: 8px 15px;
        text-transform: uppercase;
        border-radius: 20px;
        letter-spacing: 1px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        z-index: 10;
    }
    .no-movies {
        text-align: center;
        font-size: 28px;
        font-weight: bold;
        color: #5c4b33;
        margin-top: 60px;
        padding: 40px;
        background: linear-gradient(135deg, #f9f9f0 0%, #ffffff 100%);
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        border: 1px solid #c4a545;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <h2 class="text-center mt-4">Now Showing Movies</h2>

        <!-- Outer Repeater for Movies -->
        <asp:Repeater ID="rptMovies" runat="server" OnItemDataBound="rptMovies_ItemDataBound">
            <ItemTemplate>
                <div class="movie-container">
                    <span class="now-showing-badge">Now Showing</span>
                    <img src='<%# Eval("PosterPath") %>' alt='<%# Eval("Title") %> Poster' class="movie-poster" />
                    <div class="movie-details">
                        <div class="movie-title">
                            <a href='<%# GetUrl(Eval("ImdbLink").ToString()) %>' target="_blank">
                                <%# Eval("Title") %>
                            </a>
                        </div>
                        <div class="movie-meta">
                            Genre: <%# Eval("Genre") %> | Duration: <%# Eval("Duration") %>
                        </div>
                        <div class="movie-meta">
                            Director: <%# Eval("Director") %>
                        </div>
                        <div class="movie-meta">
                            Writer: <%# Eval("Writer") %>
                        </div>
                        <div class="movie-meta">
                            <strong>Showing From:</strong> <%# Eval("ShowingDate", "{0:MMMM dd, yyyy}") %>
                            <strong>to</strong> <%# Eval("EndDate", "{0:MMMM dd, yyyy}") %>
                        </div>
                        <div class="movie-description">
                            <%# Eval("Description") %>
                        </div>

                        <!-- Nested Repeater for Actors -->
                        <div class="cast-container">
                            <div class="cast-title">Cast</div>
                            <div class="cast-list">
                                <asp:Repeater ID="rptCast" runat="server">
                                    <ItemTemplate>
                                        <div class="cast-member">
                                            <img src='<%# Eval("CastPhotoPath") %>' 
                                                 alt='<%# Eval("CastName") %>' 
                                                 class="cast-photo" />
                                            <div class="cast-name">
                                                <%# Eval("CastName") %>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoMovies" runat="server" CssClass="no-movies">
            No Movies Currently Showing
        </asp:Panel>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var repeater = document.getElementById("<%= rptMovies.ClientID %>");
            var noMoviesPanel = document.getElementById("<%= pnlNoMovies.ClientID %>");
            if (!repeater || repeater.innerHTML.trim() === "") {
                noMoviesPanel.style.display = "block";
            }
        });
    </script>
</asp:Content>
