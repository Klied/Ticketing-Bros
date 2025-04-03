<%@ Page Title="Select a Movie" Language="C#" MasterPageFile="~/MasterPage.Master" 
    AutoEventWireup="true" CodeBehind="BuyTickets2.aspx.cs" Inherits="TicketingBrosMP.BuyTickets2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        
        .main-container {
            margin: 40px auto;
            max-width: 1200px;
            padding: 0 20px;
            text-align: center;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 30px;
            color: #1a1a1a;
            position: relative;
            padding-bottom: 15px;
        }
        .page-title:after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(to right, #007bff, #00c6ff);
            border-radius: 2px;
        }
      
        .movie-container {
            width: 100%;
            overflow-x: auto;
            padding: 20px 0;
            scrollbar-width: thin;
            scrollbar-color: #00c6ff #f0f0f0;
        }
        .movie-container::-webkit-scrollbar {
            height: 8px;
        }
        .movie-container::-webkit-scrollbar-track {
            background: #f0f0f0;
            border-radius: 4px;
        }
        .movie-container::-webkit-scrollbar-thumb {
            background: linear-gradient(to right, #007bff, #00c6ff);
            border-radius: 4px;
        }
     
        .movie-row {
            display: flex;
            gap: 25px;
            min-width: max-content;
            padding: 10px 5px;
        }
      
        .movie-item {
            width: 280px;
            flex: 0 0 auto;
            display: flex;
            flex-direction: column;
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 500px;
            position: relative;
        }
        .movie-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }
        
        .poster-container {
            position: relative;
            overflow: hidden;
            height: 350px;
        }
       
        .movie-poster {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .movie-item:hover .movie-poster {
            transform: scale(1.05);
        }
     
        .movie-content {
    padding: 20px;
    display: flex;
    flex-direction: column;
    flex: 1;
    align-items: stretch; 
}
        .movie-title {
    font-size: 1.25rem;
    font-weight: 700;
    margin-bottom: 10px;
    color: #1a1a1a;
    line-height: 1.4;
    min-height: 50px;
}

.movie-details {
    font-size: 0.95rem;
    color: #555;
    margin-bottom: 15px;
    line-height: 1.6;
    min-height: 40px; 
}
        .movie-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 6px;
        }
        .info-label {
            font-weight: 600;
            margin-right: 6px;
            color: #444;
        }
        
        .buy-button {
            background: linear-gradient(to right, #007bff, #00c6ff);
            border: none;
            color: white;
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            text-align: center;
            margin-top: auto;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }
        .buy-button:hover {
            background: linear-gradient(to right, #0062cc, #0099ff);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
        }
       
        .genre-tag {
            position: absolute;
            top: 15px;
            right: 15px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            z-index: 1;
        }
       
        .rating {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .star {
            color: #ffc107;
            font-size: 1rem;
            margin-right: 2px;
        }
       
        .movie-nav-container {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }
        .movie-nav-btn {
            background: #f0f0f0;
            border: none;
            color: #333;
            padding: 12px 20px;
            font-size: 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }
        .movie-nav-btn:hover {
            background: #e0e0e0;
        }
        .movie-nav-btn i {
            font-size: 1.2rem;
        }


    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="main-container">
        <h1 class="page-title">Now Showing</h1>
        <div class="movie-container">
            <div class="movie-row">
                <asp:Repeater ID="rptMovieList" runat="server">
                    <ItemTemplate>
                        <div class="movie-item">
                            <div class="poster-container">
                                <div class="genre-tag"><%# Eval("Genre") %></div>
                                <img src='<%# Eval("PosterPath") %>' alt='<%# Eval("Title") %>' class="movie-poster" />
                            </div>
                            <div class="movie-content">
                                <h3 class="movie-title"><%# Eval("Title") %></h3>
                                <div class="rating">
                                    <span class="star">★</span>
                                    <span class="star">★</span>
                                    <span class="star">★</span>
                                    <span class="star">★</span>
                                    <span class="star" style="color: #e0e0e0;">★</span>
                                </div>
                                <div class="movie-details">
                                    <div class="movie-info-item">
                                        <span class="info-label">Runtime:</span>
                                        <span><%# Eval("Duration") %> mins</span>
                                    </div>
                                </div>
                                <asp:Button ID="btnBuy" runat="server" Text="Buy Tickets" 
                                    CommandArgument='<%# Eval("ID") %>' 
                                    CssClass="buy-button"
                                    OnCommand="btnBuy_Click" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <div class="movie-nav-container">
            <button class="movie-nav-btn" id="scrollLeft" onclick="scrollMovies('left'); return false;">
                <i>←</i> Previous
            </button>
            <button class="movie-nav-btn" id="scrollRight" onclick="scrollMovies('right'); return false;">
                Next <i>→</i>
            </button>
        </div>
    </div>
    <script type="text/javascript">
        function scrollMovies(direction) {
            const container = document.querySelector('.movie-container');
            const scrollAmount = 300;
            if (direction === 'left') {
                container.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
            } else {
                container.scrollBy({ left: scrollAmount, behavior: 'smooth' });
            }
        }
    </script>
</asp:Content>
