require_relative '../rails_helper'

RSpec.describe "Routing to games", :type => :routing do
  it "routes GET / to games#new" do
    expect(:get => "/").to route_to("games#new")
  end

  it "routes GET /games/new to games#new" do
    expect(:get => "/games/new").to route_to("games#new")
  end

  it "routes GET /games/1/hit to games#hit" do 
    expect(:get => "/games/1/hit").to route_to("games#hit", :id => "1")
  end 

  it "routes GET /games/1/hold to games#hold" do 
    expect(:get => "/games/1/hold").to route_to("games#hold", :id => "1")
  end 

  it "routes GET /games/1/over to games#over" do 
    expect(:get => "/games/1/over").to route_to("games#over", :id => "1")
  end

  it "routes GET /games/join to games#join" do 
    expect(:post => "/games/join").to route_to("games#join")
  end 
end