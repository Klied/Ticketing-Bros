<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" 
    AutoEventWireup="true" CodeBehind="BuyTickets.aspx.cs" Inherits="TicketingBrosMP.BuyTickets" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
        .movie-container { max-width: 900px; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .movie-poster { width: 100%; border-radius: 10px; margin-bottom: 15px; }
        .cast-photo { width: 50px; height: 50px; border-radius: 50%; }
        .seat-checkbox { display: none; }
        
       
        .theater {
            perspective: 1000px;
            margin-bottom: 30px;
            margin-top: 30px;
        }
        .screen-container {
            text-align: center;
            margin-bottom: 35px;
        }
        .screen {
            height: 20px;
            background: linear-gradient(to bottom, #d5d5d5, #e5e5e5);
            width: 80%;
            margin: 0 auto;
            transform: rotateX(-30deg);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.7);
            position: relative;
        }
        .screen:after {
            content: "SCREEN";
            position: absolute;
            top: -25px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 14px;
            color: #555;
            font-weight: bold;
        }
        .row-label {
            display: inline-block;
            width: 30px;
            text-align: center;
            font-weight: bold;
            margin-right: 10px;
            line-height: 50px;
            color: #555;
        }
        .seat-row {
            display: flex;
            justify-content: center;
            margin-bottom: 10px;
            align-items: center;
        }
        .seat-label {
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 3px;
            border-radius: 7px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
            color: #333;
            background-color: #e7f7e7;
            border: 2px solid #555;
        }
        .seat-label:hover:not(.taken) {
            transform: scale(1.1);
            background-color: #d4f0d4;
        }
        .seat-label.selected {
            background-color: #28a745;
            color: white;
            border-color: #218838;
            transform: scale(1.05);
        }
        .seat-label.taken {
            background-color: #ff6b6b;
            color: white;
            cursor: not-allowed;
            text-decoration: line-through;
            border-color: #dc3545;
            opacity: 0.8;
        }
        .seat-label.premium {
            background-color: #f8d45c;
            border-color: #e0bd4e;
        }
        .seat-label.premium.selected {
            background-color: #e0a800;
            color: white;
            border-color: #d39e00;
        }
        .seat-legend {
            display: flex;
            justify-content: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            margin: 10px;
        }
        .legend-box {
            width: 20px;
            height: 20px;
            margin-right: 7px;
            border-radius: 5px;
            border: 1px solid #555;
        }
        .available-seat { background-color: #e7f7e7; }
        .premium-seat { background-color: #f8d45c; }
        .selected-seat { background-color: #28a745; }
        .taken-seat { background-color: #ff6b6b; }
        .aisle { width: 20px; }
        
       
        .summary-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">
        <asp:Repeater ID="rptMovies" runat="server" OnItemDataBound="rptMovies_ItemDataBound">
            <ItemTemplate>
                <div class="movie-container mb-5">
                    <div class="text-center">
                        <h2>🎥 Now Showing 🍿</h2>
                        <img src='<%# Eval("PosterPath") %>' alt='<%# Eval("Title") %> Poster' class="movie-poster" />
                    </div>
                    <div class="movie-details">
                        <h3><%# Eval("Title") %></h3>
                        <p><strong>Genre:</strong> <%# Eval("Genre") %> | <strong>Duration:</strong> <%# Eval("Duration") %></p>
                        <p><strong>Director:</strong> <%# Eval("Director") %></p>
                        <p><strong>Writer:</strong> <%# Eval("Writer") %></p>
                        <p><%# Eval("Description") %></p>
                        
                        <h4>Cast</h4>
                        
                        <asp:Repeater ID="rptCast" runat="server">
                            <ItemTemplate>
                                <div class="text-center d-inline-block me-3">
                                    <img src='<%# Eval("CastPhotoPath") %>' alt='<%# Eval("CastName") %>' class="cast-photo" /><br />
                                    <small><%# Eval("CastName") %></small>  
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <hr />
                        <h4 class="text-center">Select Your Seats</h4>
                        
                        <div class="seat-legend">
                            <div class="legend-item">
                                <div class="legend-box available-seat"></div>
                                <span>Available</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box premium-seat"></div>
                                <span>Premium</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box selected-seat"></div>
                                <span>Selected</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box taken-seat"></div>
                                <span>Taken</span>
                            </div>
                        </div>
                        
                        <div class="theater">
                            <div class="screen-container">
                                <div class="screen"></div>
                            </div>
                            
                            
                            <div id="seatingArea_<%# Eval("ID") %>">
                                <%# GenerateTheaterSeats(Container.DataItem) %>
                            </div>
                        </div>
                        
                        <div class="summary-section mt-3 text-center">
                            <h4>Selected Seats: <span id="selectedSeats_<%# Eval("ID") %>">None</span></h4>
                            <h4>Total Price: ₱<span id="totalPrice_<%# Eval("ID") %>">0</span></h4>
                            
                            <asp:HiddenField ID="hfMovieTitle" runat="server" Value='<%# Eval("Title") %>' />
                            <asp:Button ID="btnProceedToCheckout" runat="server" Text="Proceed to Checkout" CssClass="btn btn-primary mt-3" 
                                OnClick="btnProceedToCheckout_Click" CommandArgument='<%# Eval("ID") %>' />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <script>

        
        document.addEventListener('DOMContentLoaded', function () {
            var seatLabels = document.querySelectorAll('.seat-label:not(.taken)');
            seatLabels.forEach(function (label) {
                label.addEventListener('click', function () {
                    var checkbox = this.querySelector('input[type="checkbox"]');
                    checkbox.checked = !checkbox.checked;
                    this.classList.toggle('selected', checkbox.checked);
                    var movieID = checkbox.id.split('_')[1];
                    updateTotal(movieID);
                });
            });
        });

        function updateTotal(movieID) {
            var regularSeatPrice = 300;
            var premiumSeatPrice = 450;
            var checkboxes = document.querySelectorAll("input[name='seat_" + movieID + "']:checked");
            var total = 0;
            var selectedSeats = [];
            checkboxes.forEach(function (checkbox) {
                var isPremium = checkbox.closest('.seat-label').classList.contains('premium');
                total += isPremium ? premiumSeatPrice : regularSeatPrice;
                var seatInfo = checkbox.getAttribute('data-seat-info');
                selectedSeats.push(seatInfo);
            });
            document.getElementById("totalPrice_" + movieID).innerText = total;
            document.getElementById("selectedSeats_" + movieID).innerText = selectedSeats.length > 0 ? selectedSeats.join(', ') : 'None';
        }
    </script>
</asp:Content>
